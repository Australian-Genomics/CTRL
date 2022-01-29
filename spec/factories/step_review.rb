FactoryBot.define do
  factory :step_review do
    consent_step { create(:consent_step) }
    user { create(:user) }
  end
end
