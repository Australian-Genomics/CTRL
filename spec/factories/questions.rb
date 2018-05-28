FactoryBot.define do
  factory :question do
    association :step, factory: :step
  end
end
