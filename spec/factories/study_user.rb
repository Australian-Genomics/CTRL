FactoryBot.define do
  factory :study_user do
    study_id do
      existing_study_id = Study.find_by(name: 'default')&.id
      if existing_study_id.nil?
        create(:study).id
      else
        existing_study_id
      end
    end
    user_id { create(:user).id }
    participant_id do
      regex_str = '\\AA[0-4]{1}[0-9]{1}[2-4]{1}[0-9]{4}\\z'
      regex = Regexp.new(regex_str)
      regex.random_example
    end
  end
end
