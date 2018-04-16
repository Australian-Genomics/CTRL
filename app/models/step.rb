class Step < ApplicationRecord
  has_many :questions, dependent: :destroy
end
