FactoryBot.define do
  factory :consent_group do
    consent_step { create(:consent_step) }

    sequence(:order) { |n| n }

    trait :with_header do
      header { Faker::Lorem.sentence }
    end
  end
end
