class ConsentQuestion < ApplicationRecord
  QUESTION_TYPES = [
    'checkbox',
    'multiple choice',
    'checkbox agreement',
    'multiple checkboxes'
  ].freeze

  POSITIONS = %w[
    bottom
    right
  ].freeze

  has_and_belongs_to_many :conditional_duo_limitations

  belongs_to :consent_group

  has_many :answers,
           class_name:  'QuestionAnswer',
           dependent:   :destroy

  has_many :question_options, dependent: :destroy

  validates :question, presence: true
  validate :default_answer_is_valid
  validate :answers_are_valid

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

  def valid_answers
    case question_type
    when 'checkbox'
      %w[yes no]
    when 'multiple choice'
      question_options.map(&:value)
    when 'checkbox agreement'
      %w[yes no]
    when 'multiple checkboxes'
      question_options.map(&:value)
    end
  end

  private

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

  def answers_are_valid
    valid_answers_ = valid_answers
    return true if valid_answers.nil?

    answer_strings = answers.map(&:answer).to_set.to_a
    invalid_answer_strings = answer_strings.reject { |s| valid_answers_.include?(s) }

    if invalid_answer_strings.empty?
      true
    else
      errors.add(
        :answers,
        "This question's options and answers are incompatible with each other. The answers include: #{invalid_answer_strings.join(', ')}. The question options are: #{valid_answers.join(', ')}."
      )
      false
    end
  end

  def destroy_associated_conditional_duo_limitations
    conditional_duo_limitations.each(&:destroy!)
  end
end
