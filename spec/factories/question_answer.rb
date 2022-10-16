FactoryBot.define do
  factory :question_answer do
    transient {
      traits { [] }
    }
    consent_question { create(:consent_question, *traits) }
    user { create(:user) }

    answer { consent_question.default_answer }
  end
end
