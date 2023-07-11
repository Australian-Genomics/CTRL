FactoryBot.define do
  factory :study do
    name { 'default' }
    participant_id_format { '\\AA[0-4]{1}[0-9]{1}[2-4]{1}[0-9]{4}\\z' }
  end
end
