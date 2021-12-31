class Step < ApplicationRecord
  include QuestionsHelper

  REDCAP_CONNECTED_STEPS = [4, 5].freeze
  QUESTIONABLE_STEPS = [2, 3, 4, 5].freeze

  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions

  belongs_to :user

  after_create :create_step_default_questions

  delegate :study_id, to: :user, prefix: true, allow_nil: true

  def build_question_for_step(user_id)
    range_of_values_for(number).each do |time|
      questions.build(question_id: time, user_id: user_id)
    end
  end

  def upload_with_redcap(step_params)
    return unless update(step_params)
    return unless redcap_connection_enabled?
    UploadRedcapDetailsJob.perform_later(id)
  end

  def create_step_default_questions
    return if QUESTIONABLE_STEPS.exclude?(number)
    qus_key = number_and_qus_key_hash(number)
    questions_attrs = range_of_values_for(number).step(1).map do |num|
      { question_id: num, user_id: user_id, answer: default_answer(qus_key.to_sym, num) }
    end
    questions.create(questions_attrs)
  end

  private

  def range_of_values_for(step)
    case step
    when 2
      (1..11)
    when 3
      (12..15)
    when 4
      (16..21)
    when 5
      (22..34)
    end
  end

  def default_answer(key, question_id)
    qus = all_questions[key].select { |x| x[:question_id] == question_id }.first
    begin
      Question.answers[qus[:default_value].to_s]
    rescue StandardError
      nil
    end
  end

  def number_and_qus_key_hash(step)
    { 2 => 'step_two_questions', 3 => 'step_three_questions',
      4 => 'step_four_questions', 5 => 'step_five_questions' }[step]
  end

  def redcap_connection_enabled?
    REDCAP_CONNECTED_STEPS.include?(number) && ENV['REDCAP_CONNECTION_ENABLED'].eql?('true')
  end
end
