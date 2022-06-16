class ModalFallback < ApplicationRecord
  belongs_to :consent_step

  validates :cancel_btn, presence: true
  validates :description, presence: true
  validates :review_answers_btn, presence: true
end
