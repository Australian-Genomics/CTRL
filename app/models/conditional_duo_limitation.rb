require 'json-schema'

# TODO: Tests
# TODO: Add documentation about conditionals in Active Admin

class ConditionalDuoLimitation < ApplicationRecord
  has_and_belongs_to_many :consent_questions

  after_save :associate_with_consent_questions

  validates :json, presence: true
  validate :validate_json, if: -> { json.present? }

  def parsed_json
    JSON.parse(json)
  end

  def condition
    parsed_json['condition']
  end

  def duo_limitation
    parsed_json['duoLimitation']
  end

  def eval_condition(user)
    all_associated_consent_questions_have_answers(user) &&
      eval_condition_recursively(user, condition)
  end

  #
  # Example:
  #
  #   x = {
  #     "code": "DUO:1",
  #     "modifiers": [
  #       { "code": "DUO:2", "regions": ["US"] },
  #       { "code": "DUO:3", "regions": ["EU"] }
  #     ]
  #   }
  #
  #   y = {
  #     "code": "DUO:1",
  #     "modifiers": [
  #       { "code": "DUO:2", "regions": ["AU"] },
  #       { "code": "DUO:4", "regions": ["NZ"] }
  #     ]
  #   }
  #
  #   merge(x, y) == {
  #     "code": "DUO:1",
  #     "modifiers": [
  #       { "code": "DUO:2", "regions": ["US", "AU"] }
  #       { "code": "DUO:3", "regions": ["EU"] }
  #       { "code": "DUO:4", "regions": ["NZ"] }
  #     ]
  #   }
  #
  def self.merge(x, y)
    if x.class == Array and y.class == Array
      return merge_arrays(x, y)
    end

    if x.class != Hash or y.class != Hash
      return x == y ? x : nil
    end

    if x.keys.to_set != y.keys.to_set
      return nil
    end

    x.keys.map do |key|
      merged = merge(x[key], y[key])
      if merged.nil?
        return
      else
        [key, merged]
      end
    end.to_h
  end

  def self.merge_into_array(array, x)
    was_merged = false

    merged = array.map do |y|
      merged = merge(y, x)
      was_merged ||= !merged.nil?
      merged.nil? ? y : merged
    end

    was_merged ? merged : array + [x]
  end

  def self.merge_arrays(xs, ys)
    (xs + ys).reduce([]) do |acc, z|
      merge_into_array(acc, z)
    end
  end

  private

  def validate_json
    schema_validation_errors = begin
      JSON::Validator.fully_validate(
        Rails.root.join(
          'config', 'conditional_duo_limitation_schema.json').to_s,
        json,
        :strict => true,
        :json => true,
        :clear_cache => true,
      )
    rescue JSON::Schema::JsonParseError => e
      [e.message]
    end

    # Validate that `json` matches the schema
    schema_validation_errors.each do |schema_validation_error|
      errors.add(:json, schema_validation_error)
    end

    if schema_validation_errors.length > 0
      return false
    end

    # Validate that `json`'s `consent_question_id` and `answer` refer to real things in
    # the DB.
    semantics_validation_errors = validate_equals_exprs(extract_equals_exprs)

    semantics_validation_errors.each do |semantics_validation_error|
      errors.add(:json, semantics_validation_error)
    end

    if semantics_validation_errors.length > 0
      return false
    end

    return true
  end

  def associate_with_consent_questions
    equals_exprs = extract_equals_exprs

    self.consent_questions = equals_exprs.map do |equals_expr|
      ConsentQuestion.find_by(id: equals_expr['consent_question_id'])
    end
  end

  def validate_equals_exprs(equals_exprs)
    equals_exprs.map do |equals_expr|
      validate_equals_expr(equals_expr)
    end.select do |error|
      not error.nil?
    end
  end

  def validate_equals_expr(equals_expr)
    expected_id = equals_expr['consent_question_id']
    expected_value = equals_expr['answer']

    consent_question = ConsentQuestion.find_by(id: expected_id)
    if consent_question.nil?
      return "No consent question exists having the consent_question_id " +
        "#{expected_id}"
    end

    values = consent_question.question_options.map do |question_option|
      question_option.value
    end.to_set.merge (
      if consent_question.question_type == 'checkbox agreement'
        ['yes', 'no'].to_set
      elsif consent_question.question_type == 'checkbox'
        ['yes', 'no'].to_set
      else
        [].to_set
      end
    )

    if not values.include?(expected_value)
      return (
        "The question whose consent_question_id is #{expected_id} can only " +
        "have the values (#{values.to_a.join(', ')})")
    end
  end

  def is_boolean_expr(parsed_json)
    [TrueClass, FalseClass].to_set.include?(parsed_json.class)
  end

  def is_equals_expr(parsed_json)
    parsed_json.class == Hash &&
      parsed_json.keys.to_set == ['consent_question_id', 'answer'].to_set
  end

  def is_and_expr(parsed_json)
    parsed_json.class == Hash && parsed_json.keys.to_set == ['and'].to_set
  end

  def is_or_expr(parsed_json)
    parsed_json.class == Hash && parsed_json.keys.to_set == ['or'].to_set
  end

  def is_not_expr(parsed_json)
    parsed_json.class == Hash && parsed_json.keys.to_set == ['not'].to_set
  end

  def extract_equals_exprs
    extract_equals_exprs_from_condition(condition)
  end

  def extract_equals_exprs_from_condition(parsed_json)
    if is_equals_expr(parsed_json)
      [parsed_json]
    elsif is_and_expr(parsed_json)
      parsed_json['and'].flat_map do |expr|
        extract_equals_exprs_from_condition(expr)
      end
    elsif is_or_expr(parsed_json)
      parsed_json['or'].flat_map do |expr|
        extract_equals_exprs_from_condition(expr)
      end
    elsif is_not_expr(parsed_json)
      extract_equals_exprs_from_condition(parsed_json['not'])
    elsif is_boolean_expr(parsed_json)
      []
    else
      raise StandardError.new "Unexpected expression " + parsed_json.to_s
    end
  end

  def all_associated_consent_questions_have_answers(user)
    user_id = user.id
    extract_equals_exprs.all? do |equals_expr|
      QuestionAnswer.find_by(
        consent_question_id: equals_expr['consent_question_id'],
        user_id: user_id,
      ).present?
    end
  end

  def eval_condition_recursively(user, parsed_json)
    if is_equals_expr(parsed_json)
      QuestionAnswer.find_by(
        consent_question_id: parsed_json['consent_question_id'],
        user_id: user.id,
        answer: parsed_json['answer'],
      ).present?
    elsif is_and_expr(parsed_json)
      parsed_json['and'].all? { |expr| eval_condition_recursively(user, expr) }
    elsif is_or_expr(parsed_json)
      parsed_json['or'].any? { |expr| eval_condition_recursively(user, expr) }
    elsif is_not_expr(parsed_json)
      not eval_condition_recursively(user, parsed_json['not'])
    elsif is_boolean_expr(parsed_json)
      parsed_json
    else
      raise StandardError.new "Unexpected expression " + parsed_json.to_s
    end
  end
end
