class QuestionAnswer < ApplicationRecord
  belongs_to :consent_question
  belongs_to :user

  validates :user_id, uniqueness: { scope: :consent_question_id }, unless: Proc.new { |ans| ans.consent_question.question_type == "multiple checkboxes" }
  validates :answer, presence: true
end
