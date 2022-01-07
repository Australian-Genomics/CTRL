class StepReview < ApplicationRecord
  belongs_to :user
  belongs_to :consent_step

  validates :user_id, presence: true
  validates :consent_step_id, presence: true
end
