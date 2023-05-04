class Step < ApplicationRecord
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions

  belongs_to :user

  delegate :participant_id, to: :user, prefix: true, allow_nil: true
end
