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
    study_id 'Curve18'
  end
end
