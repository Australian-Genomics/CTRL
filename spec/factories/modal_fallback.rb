FactoryBot.define do
  factory :modal_fallback do
    consent_step { create(:consent_step) }

    cancel_btn { Faker::Lorem.characters(number: 10) }
    description { Faker::Lorem.paragraph }
    review_answers_btn { Faker::Lorem.characters(number: 10) }
    small_note { Faker::Lorem.paragraph }
  end
end
