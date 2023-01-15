class ApiUser < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :token_digest, presence: true
end
