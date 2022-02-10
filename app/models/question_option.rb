class QuestionOption < ApplicationRecord
  belongs_to :consent_question

  validates :value,
    presence: true,
    uniqueness: { scope: :consent_question_id }

  validate :consent_question_type, on: :create

  private

  def consent_question_type
    return if multiple_choice_parent?

    errors.add(:consent_question_id, 'incompatible question')
  end

  def multiple_choice_parent?
    consent_question&.question_type == 'multiple choice'
  end
end
