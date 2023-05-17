FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@email.com"
    end

    first_name 'sushant'
    family_name 'ahuja'
    dob '22-05-1995'
    password 'password'
    password_confirmation 'password'
    participant_id do
      regex_str = '\\AA[0-4]{1}[0-9]{1}[2-4]{1}[0-9]{4}\\z'
      regex = Regexp.new(regex_str)

      ParticipantIdFormat.create(participant_id_format: regex_str)
      regex.random_example
    end
    suburb 'Bankstown.'
    preferred_contact_method 'Email'
    is_parent 'true'
    kin_first_name 'Luca'
    kin_email 'a@b.co'
    kin_family_name "D'Souza"
    kin_contact_no '98978146'
    child_first_name 'Alisha'
    child_family_name 'Dubb'
    child_dob '30-05-1995'
  end
end
