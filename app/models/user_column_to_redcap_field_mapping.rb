class UserColumnToRedcapFieldMapping < ApplicationRecord
  validates :user_column, uniqueness: true
  validates :redcap_field, uniqueness: { scope: :redcap_event_name }
end
