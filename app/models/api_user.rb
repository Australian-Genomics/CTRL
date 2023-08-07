class ApiUser < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :token_digest, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "study_id", "token_digest", "updated_at"]
  end
end
