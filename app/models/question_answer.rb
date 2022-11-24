class QuestionAnswer < ApplicationRecord
  belongs_to :consent_question
  belongs_to :user

  validates :user_id, uniqueness: { scope: :consent_question_id }, unless: Proc.new { |ans| ans&.consent_question&.question_type == "multiple checkboxes" }
  validates :answer, presence: true

  after_save :upload_redcap_details
  before_destroy :destroy_redcap_details

  def upload_redcap_details
    UploadRedcapDetails.perform(:question_answer_to_redcap_response, self)
  end

  def destroy_redcap_details
    UploadRedcapDetails.perform(:question_answer_to_redcap_response, self, true)
  end
end
