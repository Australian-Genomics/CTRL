FactoryBot.define do
  factory :question_option do
    consent_question { create(:consent_question, :multiple_choice) }

    value { Faker::Lorem.characters(number: 10) }
  end
end
