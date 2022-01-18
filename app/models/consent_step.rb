class ConsentStep < ApplicationRecord
  has_many :consent_groups, dependent: :destroy

  has_many :users_reviewed,
    class_name:  'StepReview',
    dependent: :destroy

  has_one :modal_fallback, dependent: :destroy
end
