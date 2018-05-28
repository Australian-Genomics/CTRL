FactoryBot.define do
  factory :step do
    association :user, factory: :user
  end
end
