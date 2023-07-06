class StudyUser < ApplicationRecord
  self.table_name = 'studies_users'

  belongs_to :study
  belongs_to :user

  validates :participant_id, presence: true, uniqueness: true
  validate :check_participant_id_format_by_regex, if: -> { participant_id.present? }, on: :create
  validate :check_participant_id_format_by_redcap, if: -> { participant_id.present? }, on: :create

  after_save :upload_redcap_details

  def check_participant_id_format_by_regex
    format = Regexp.new(study.participant_id_format)
    if participant_id.match(format)
      true
    else
      errors.add(:participant_id, 'Invalid format')
      false
    end
  end

  def check_participant_id_format_by_redcap
    redcap_email_field = UserColumnToRedcapFieldMapping.find_by(
      user_column: 'email'
    )&.redcap_field

    if redcap_email_field.nil?
      return true # CTRL was configured not to use REDCap's email field
    end

    redcap_details = Redcap.filter_repeat_instruments download_redcap_details

    if redcap_details.nil?
      true # REDCap connection is probably disabled
    elsif redcap_details.empty?
      errors.add(:participant_id, 'Participant ID not found')
      false
    elsif redcap_details.length == 1
      if redcap_details[0][redcap_email_field] != email
        errors.add(:participant_id, 'Participant ID does not match the provided email address')
        false
      else
        true
      end
    else
      raise StandardError, 'REDCap returned more than one record for the given participant ID'
    end
  end

  def download_redcap_details
    Redcap.perform(
      :user_to_export_redcap_response,
      :get_export_payload,
      record: self
    )
  end

  def upload_redcap_details
    Redcap.perform(
      :user_to_import_redcap_response,
      :get_import_payload,
      record: user,
      expected_count: 1
    )
  end
end
