class ConsentQuestion < ApplicationRecord
  QUESTION_TYPES = [
    'checkbox',
    'multiple choice',
    'checkbox agreement',
    'multiple checkboxes'
  ]

  POSITIONS = [
    'bottom',
    'right'
  ]

  has_and_belongs_to_many :conditional_duo_limitations

  belongs_to :consent_group

  has_many :answers,
    class_name:  'QuestionAnswer',
    dependent:   :destroy

  has_many :question_options, dependent: :destroy

  validates :question, presence: true
  validate :default_answer_is_valid

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

  scope :published_ordered, -> {
    where(is_published: true).order(order: :asc)
  }

  before_destroy :destroy_associated_conditional_duo_limitations

  private

  def valid_answers
    case question_type
    when 'checkbox'
      ['yes', 'no']
    when 'multiple choice'
      question_options.map { |question_option| question_option.value }
    when 'checkbox agreement'
      ['yes', 'no']
    when 'multiple checkboxes'
      question_options.map { |question_option| question_option.value }
    end
  end

  def default_answer_is_valid
    if valid_answers.nil?
      true
    elsif valid_answers.include? default_answer
      true
    else
      errors.add(:default_answer, "Must be one of: #{valid_answers.join(', ')}")
      false
    end
  end

  def destroy_associated_conditional_duo_limitations
    conditional_duo_limitations.each do |conditional_duo_limitation|
      conditional_duo_limitation.destroy!
    end
  end
end
