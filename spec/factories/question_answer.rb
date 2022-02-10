FactoryBot.define do
  factory :question_answer do
    consent_question { create(:consent_question) }
    user { create(:user) }

    answer { consent_question.default_answer }
  end
end
