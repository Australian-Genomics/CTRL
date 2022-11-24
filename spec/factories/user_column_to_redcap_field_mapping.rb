FactoryBot.define do
  factory :user_column_to_redcap_field_mapping do
    user_column { "#{user_column}" }
    redcap_field { "#{redcap_field}" }
    redcap_event_name { "#{redcap_event_name}" }
  end
end
