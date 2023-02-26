FactoryBot.define do
  factory :question_option do
    value { Faker::Lorem.characters(number: 10) }

    trait :with_consent_question do
      consent_question { create(:consent_question, :multiple_choice) }
    end
  end
end
