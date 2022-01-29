class ConsentGroup < ApplicationRecord
  belongs_to :consent_step

  has_many :consent_questions, dependent: :destroy

  validates :order,
    numericality: { greater_than: 0 },
    uniqueness: { scope: :consent_step_id }

  accepts_nested_attributes_for :consent_questions, allow_destroy: true

  scope :ordered, -> { order(order: :asc) }
end
