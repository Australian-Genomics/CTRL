class UserColumnToRedcapFieldMapping < ApplicationRecord
  validates :user_column, uniqueness: true
  validates :redcap_field, uniqueness: { scope: :redcap_event_name }

  def self.ransackable_attributes(auth_object = nil)
    ["id", "redcap_event_name", "redcap_field", "user_column"]
  end
end
