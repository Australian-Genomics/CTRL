class QuestionAnswer < ApplicationRecord
  belongs_to :consent_question
  belongs_to :user

  validates :user_id, uniqueness: { scope: :consent_question_id }, unless: Proc.new { |ans| ans&.consent_question&.question_type == "multiple checkboxes" }
  validates :answer, presence: true

  after_save :upload_redcap_details
  before_destroy :destroy_redcap_details

  def upload_redcap_details
    Redcap.perform(
      :question_answer_to_redcap_response,
      :get_import_payload,
      record: self,
      expected_count: 1)
  end

  def destroy_redcap_details
    Redcap.perform(
      :question_answer_to_redcap_response,
      :get_import_payload,
      record: self,
      destroy: true,
      expected_count: 1)
  end
end
