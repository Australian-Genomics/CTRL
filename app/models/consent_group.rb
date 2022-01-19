class ConsentGroup < ApplicationRecord
  belongs_to :consent_step

  has_many :consent_questions, dependent: :destroy

  accepts_nested_attributes_for :consent_questions, allow_destroy: true

  scope :ordered, -> {
     order(order: :asc)
  }
end
