require 'json-schema'

# TODO: Merge documents
# TODO: Add documentation about conditionals in Active Admin

class ConditionalDuoLimitation < ApplicationRecord
  has_and_belongs_to_many :consent_questions

  after_save :associate_with_consent_questions

  validates :json, presence: true
  validate :validate_json, if: -> { json.present? }

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

  def is_equals_expr(parsed_json)
    parsed_json.keys.to_set == ['consent_question_id', 'answer'].to_set
  end

  def is_and_expr(parsed_json)
    parsed_json.keys.to_set == ['and'].to_set
  end

  def is_or_expr(parsed_json)
    parsed_json.keys.to_set == ['or'].to_set
  end

  def is_not_expr(parsed_json)
    parsed_json.keys.to_set == ['not'].to_set
  end

  def extract_equals_exprs
    parsed_json = JSON.parse(json)
    extract_equals_exprs_from_condition(parsed_json['condition'])
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
    else
      raise StandardError.new "Unexpected expression " + parsed_json.to_s
    end
  end

  def evaluate_condition(user)
    parsed_json = JSON.parse(json)
    evaluate_condition_(user, parsed_json['condition'])
  end

  def evaluate_condition_(user, parsed_json)
    if is_equals_expr(parsed_json)
      QuestionAnswer.find_by(
        consent_question_id: parsed_json['consent_question_id'],
        user_id: user.id,
        answer: parsed_json['answer'],
      ).present?
    elsif is_and_expr(parsed_json)
      parsed_json['and'].all? { |expr| evaluate_condition_(user, expr) }
    elsif is_or_expr(parsed_json)
      parsed_json['or'].any? { |expr| evaluate_condition_(user, expr) }
    elsif is_not_expr(parsed_json)
      not evaluate_condition_(user, parsed_json['not'])
    else
      raise StandardError.new "Unexpected expression " + parsed_json.to_s
    end
  end
end
