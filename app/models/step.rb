class Step < ApplicationRecord
  REDCAP_CONNECTED_STEPS = [4, 5].freeze

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
    UploadRedcapDetailsJob.perform_later(id) if REDCAP_CONNECTED_STEPS.include?(number)
  end

  def create_step_default_questions
    return if number.nil? ||
    unless number == 1
      questions_attrs = range_of_values_for(number).step(1).map do |time|
        { question_id: time, user_id: user_id }
      end
      questions.create(questions_attrs)
    end
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
end
