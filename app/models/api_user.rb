class ApiUser < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :token_digest, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id name study_id token_digest updated_at]
  end
end
