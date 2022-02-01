class ConsentQuestion < ApplicationRecord
  QUESTION_TYPES = [
    'checkbox',
    'multiple choice',
    'checkbox agreement'
  ]

  POSITIONS = [
    'bottom',
    'right'
  ]

  belongs_to :consent_group

  has_many :answers,
    class_name:  'QuestionAnswer',
    dependent:   :destroy

  has_many :question_options, dependent: :destroy

  validates :question, presence: true
  validates :default_answer, presence: true

  validates :order,
    numericality: { greater_than: 0 },
    uniqueness: { scope: :consent_group_id }, on: :create

  validates :answer_choices_position,
    presence: true,
    inclusion: {
      in: POSITIONS
    }

  validates :question_type,
    presence: true,
    inclusion: {
      in: QUESTION_TYPES
    }

  accepts_nested_attributes_for :question_options, allow_destroy: true

  alias_attribute :options, :question_options

  scope :ordered, -> {
    order(order: :asc)
  }
end
