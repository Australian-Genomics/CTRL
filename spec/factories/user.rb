FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@email.com"
    end

    first_name 'sushant'
    family_name 'ahuja'
    password 'password'
    password_confirmation 'password'
    flagship 'Acute Care Genomic Testing'
    current_consent_step 'step_1'
    study_id 'Curve18'
  end
end
