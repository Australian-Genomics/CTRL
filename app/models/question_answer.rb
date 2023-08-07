class QuestionAnswer < ApplicationRecord
  belongs_to :consent_question
  belongs_to :user

  validates :user_id, uniqueness: { scope: :consent_question_id }, unless: proc { |ans| ans&.consent_question&.question_type == 'multiple checkboxes' }

  validates :answer, presence: true
  validate :answer_is_valid, if: -> { answer.present? }

  after_save :upload_redcap_details
  before_destroy :destroy_redcap_details

  def self.ransackable_attributes(auth_object = nil)
    ["answer", "consent_question_id", "created_at", "id", "updated_at", "user_id"]
  end

  private

  def upload_redcap_details
    Redcap.perform(
      :question_answer_to_redcap_response,
      :get_import_payload,
      record: self,
      expected_count: 1
    )
  end

  def destroy_redcap_details
    Redcap.perform(
      :question_answer_to_redcap_response,
      :get_import_payload,
      record: self,
      destroy: true,
      expected_count: 1
    )
  end

  def answer_is_valid
    valid_answers = consent_question&.valid_answers
    if valid_answers.nil?
      true
    elsif valid_answers.include? answer
      true
    else
      errors.add(:answer, "Must be one of: #{valid_answers.join(', ')}")
      false
    end
  end
end
