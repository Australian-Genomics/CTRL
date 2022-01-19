class ConsentQuestion < ApplicationRecord
  QUESTION_TYPES = [
    'checkbox',
    'multiple choice',
    'short answer',
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

  scope :ordered, -> {
     order(order: :asc)
  }
end
