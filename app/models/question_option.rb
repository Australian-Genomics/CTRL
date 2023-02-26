class QuestionOption < ApplicationRecord
  belongs_to :consent_question

  validates :value,
    presence: true,
    uniqueness: { scope: :consent_question_id }

  validate :consent_question_type, on: :create

  before_destroy :associated_question_still_valid?

  private

  def consent_question_type
    return if multiple_choice_parent?

    errors.add(:consent_question_id, 'incompatible question')
  end

  def multiple_choice_parent?
    consent_question&.question_type == 'multiple choice' || consent_question&.question_type == 'multiple checkboxes'
  end

  def associated_question_still_valid?
    if !destroyed_by_association && consent_question.default_answer == value
      throw "Deleting the question option '#{value}' would make the associated consent question invalid"
    end
  end
end
