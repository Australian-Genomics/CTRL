FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@email.com"
    end

    first_name 'sushant'
    family_name 'ahuja'
    dob '22-05-1995'
    flagship 'Genetic Immunology'
    password 'password'
    password_confirmation 'password'
    study_id 'Curve18'
    suburb 'Bankstown.'
    preferred_contact_method 'Email'
    is_parent 'true'
    kin_first_name 'Luca'
    kin_family_name "D'Souza"
    kin_contact_no '98978146'
    child_first_name 'Alisha'
    child_family_name 'Dubb'
    child_dob '30-05-1995'
  end
end
