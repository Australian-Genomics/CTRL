class Step < ApplicationRecord
  REDCAP_CONNECTED_STEPS = [4, 5].freeze

  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions

  belongs_to :user

  delegate :study_id, to: :user, prefix: true, allow_nil: true

  def upload_with_redcap(step_params)
    return unless update(step_params)
    return unless redcap_connection_enabled?

    UploadRedcapDetailsJob.perform_later(id)
  end

  private

  def redcap_connection_enabled?
    REDCAP_CONNECTED_STEPS.include?(number) && ENV['REDCAP_CONNECTION_ENABLED'].eql?('true')
  end
end
