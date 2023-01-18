require 'json-schema'

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
    parsed_json['duo_limitation']
  end

  def eval_condition(user)
    eval_condition_recursively(user, condition)
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

    # Validate that `json`'s `consent_question_id` and `answer` refer to real
    # things in the DB.
    semantics_validation_errors = validate_consent_question_ids(
        extract_equals_exprs + extract_exists_exprs
      ) + validate_answers(extract_equals_exprs)

    semantics_validation_errors.each do |semantics_validation_error|
      errors.add(:json, semantics_validation_error)
    end

    if semantics_validation_errors.length > 0
      return false
    end

    return true
  end

  def associate_with_consent_questions
    exprs = extract_equals_exprs + extract_exists_exprs

    self.consent_questions = exprs.map do |expr|
      ConsentQuestion.find_by(id: expr['consent_question_id'])
    end
  end

  def validate_consent_question_ids(exprs)
    exprs.flat_map { |expr| validate_consent_question_id(expr) }
  end

  def validate_answers(equals_exprs)
    equals_exprs.flat_map { |equals_expr| validate_answer(equals_expr) }
  end

  def validate_consent_question_id(expr)
    consent_question_id = expr['consent_question_id']

    if ConsentQuestion.find_by(id: consent_question_id).nil?
      ["No consent question exists having the consent_question_id " +
        "#{consent_question_id}"]
    else
      []
    end
  end

  def validate_answer(equals_expr)
    consent_question_id = equals_expr['consent_question_id']
    answer = equals_expr['answer']

    consent_question = ConsentQuestion.find_by(id: consent_question_id)

    if consent_question.nil?
      return []
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

    if values.include?(answer)
      []
    else
      [
        "The question whose consent_question_id is #{consent_question_id} " +
        "can only have the values (#{values.to_a.join(', ')})"]
    end
  end

  def is_boolean_expr(parsed_json)
    [TrueClass, FalseClass].to_set.include?(parsed_json.class)
  end

  def is_equals_expr(parsed_json)
    parsed_json.class == Hash &&
      parsed_json.keys.to_set == ['consent_question_id', 'answer'].to_set
  end

  def is_exists_expr(parsed_json)
    parsed_json.class == Hash &&
      parsed_json.keys.to_set == ['consent_question_id', 'answer_exists'].to_set
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
    flat_map_condition(condition) { |expr| is_equals_expr(expr) ? [expr] : [] }
  end

  def extract_exists_exprs
    flat_map_condition(condition) { |expr| is_exists_expr(expr) ? [expr] : [] }
  end

  def flat_map_condition(parsed_json, &block)
    block.call(parsed_json) + if is_equals_expr(parsed_json)
      []
    elsif is_exists_expr(parsed_json)
      flat_map_condition(parsed_json['answer_exists'], &block)
    elsif is_and_expr(parsed_json)
      parsed_json['and'].flat_map { |expr| flat_map_condition(expr, &block) }
    elsif is_or_expr(parsed_json)
      parsed_json['or'].flat_map { |expr| flat_map_condition(expr, &block) }
    elsif is_not_expr(parsed_json)
      flat_map_condition(parsed_json['not'], &block)
    elsif is_boolean_expr(parsed_json)
      []
    else
      raise StandardError.new "Unexpected expression " + parsed_json.to_s
    end
  end

  def eval_condition_recursively(user, parsed_json)
    if is_equals_expr(parsed_json)
      QuestionAnswer.find_by(
        consent_question_id: parsed_json['consent_question_id'],
        user_id: user.id,
        answer: parsed_json['answer'],
      ).present?
    elsif is_exists_expr(parsed_json)
      QuestionAnswer.find_by(
        consent_question_id: parsed_json['consent_question_id'],
        user_id: user.id,
      ).present? == eval_condition_recursively(
        user,
        parsed_json['answer_exists'],
      )
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
