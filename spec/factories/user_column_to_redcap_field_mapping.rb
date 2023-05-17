FactoryBot.define do
  factory :user_column_to_redcap_field_mapping do
    user_column { user_column.to_s }
    redcap_field { redcap_field.to_s }
    redcap_event_name { redcap_event_name.to_s }
  end
end
