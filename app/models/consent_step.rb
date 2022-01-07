class ConsentStep < ApplicationRecord
  has_many :consent_groups, dependent: :destroy

  has_many :users_reviewed,
    class_name:  'StepReview',
    dependent: :destroy
end
