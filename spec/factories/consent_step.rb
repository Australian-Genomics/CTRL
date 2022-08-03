FactoryBot.define do
  factory :consent_step do
    sequence(:order) { |n| n + 1 }
    description { Faker::Lorem.paragraph }
    popover { Faker::Lorem.paragraph }
    title { Faker::Lorem.sentence }
  end
end
