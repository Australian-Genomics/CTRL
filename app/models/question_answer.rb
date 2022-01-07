class QuestionAnswer < ApplicationRecord
  belongs_to :consent_question
  belongs_to :user
end
