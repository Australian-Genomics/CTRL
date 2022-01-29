class QuestionAnswer < ApplicationRecord
  belongs_to :consent_question
  belongs_to :user

  validates :user_id, uniqueness: { scope: :consent_question_id }
  validates :answer, presence: true
end
