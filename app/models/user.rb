class User < ApplicationRecord
  attr_accessor :skip_validation

  has_paper_trail
  include UserDateValidator
  include NextOfKinRegistrationValidator

  has_many :reviewed_steps,
    class_name:  'StepReview',
    dependent:   :destroy

  has_many :answers,
    class_name:  'QuestionAnswer',
    dependent:   :destroy

  has_many :steps, dependent: :destroy, class_name: 'Step'

  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :family_name, presence: true

  validates :preferred_contact_method,
    presence: true,
    on: :update,
    unless: :skip_validation

  validates :kin_first_name,
    :kin_family_name,
    presence: true,
    if: :next_of_kin_needed_to_register?

  validates :kin_email, format: {
    with: Devise::email_regexp,
    message: 'Is invalid'
  }, if: :do_validate_kin_email?

  validate :date_of_birth_in_future,
    unless: :skip_validation

  validate :kin_details_and_child_details,
    :child_date_of_birth_in_future,
    on: :update, unless: :skip_validation

  validates :terms_and_conditions, acceptance: true

  validates :study_id, presence: true
  validate :check_study_code_by_regex, if: -> { study_id.present? }, on: :create
  validate :check_study_code_by_redcap, if: -> { study_id.present? }, on: :create

  accepts_nested_attributes_for :steps

  enum state: %w[ACT NSW NT QLD SA TAS VIC WA]
  enum preferred_contact_method: %w[Email Phone Mail]

  after_save :upload_redcap_details

  def do_validate_kin_email?
    next_of_kin_needed_to_register? || (persisted? && !is_parent)
  end

  def kin_details_and_child_details
    if is_parent == false
      validates_presence_of :kin_first_name, :kin_family_name, :kin_contact_no
    elsif is_parent == true
      validates_presence_of :child_first_name, :child_family_name
    end
  end

  def reset_password(new_password, new_password_confirmation)
    self.skip_validation = true
    if new_password.present?
      self.password = new_password
      self.password_confirmation = new_password_confirmation
      save
    else
      errors.add(:password, :blank)
      false
    end
  end

  def check_study_code_by_regex
    codes = StudyCode.pluck(:title)
    if codes.all? { |code| Regexp.new(code).match(study_id) }
      true
    else
      errors.add(:study_id, 'Invalid format')
      false
    end
  end

  def check_study_code_by_redcap
    redcap_email_field = UserColumnToRedcapFieldMapping.find_by(
      user_column: 'email'
    )&.redcap_field

    if redcap_email_field.nil?
      return true # CTRL was configured not to use REDCap's email field
    end

    redcap_details = download_redcap_details

    if redcap_details.nil?
      true # REDCap connection is probably disabled
    elsif redcap_details.length == 0
      errors.add(:study_id, 'Study ID not found')
      false
    elsif redcap_details.length == 1
      if redcap_details[0][redcap_email_field] != email
        errors.add(:study_id, 'Study ID does not match the provided email address')
        false
      else
        true
      end
    else
      raise Exception.new 'REDCap returned more than one record for the given study ID'
    end
  end

  def upload_redcap_details
    Redcap.perform(
      :user_to_redcap_response,
      :get_import_payload,
      record: self,
      expected_count: 1)
  end

  def download_redcap_details
    Redcap.perform(
      :identity_data_fetcher,
      :get_export_payload,
      record: study_id)
  end
end
