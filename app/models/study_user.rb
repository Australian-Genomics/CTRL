class StudyUser < ApplicationRecord
  self.table_name = "studies_users"

  belongs_to :study
  belongs_to :user
end
