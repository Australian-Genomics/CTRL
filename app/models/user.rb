class User < ApplicationRecord
  devise :two_factor_authenticatable
  attr_accessor :skip_validation, :participant_id

  has_paper_trail
  include UserDateValidator
  include NextOfKinRegistrationValidator

  has_many :reviewed_steps,
           class_name: 'StepReview',
           dependent: :destroy

  has_many :answers,
           class_name: 'QuestionAnswer',
           dependent: :destroy

  has_many :steps, dependent: :destroy, class_name: 'Step'

  has_many :study_users, dependent: :destroy
  has_many :studies, through: :study_users

  devise :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :family_name, presence: true

  validates :preferred_contact_method,
            presence: true,
            on: :update,
            unless: :skip_validation

  validate :date_of_birth_in_future,
           unless: :skip_validation

  validate :kin_details_and_child_details_on_create,
           :child_date_of_birth_in_future,
           on: :create, if: :next_of_kin_needed_to_register?

  validate :kin_details_and_child_details_on_update,
           :child_date_of_birth_in_future,
           on: :update, unless: :skip_validation

  validates :terms_and_conditions, acceptance: true

  accepts_nested_attributes_for :steps, :study_users

  enum state: %w[ACT NSW NT QLD SA TAS VIC WA]
  enum preferred_contact_method: %w[Email Phone Mail]

  after_save :upload_redcap_details

  def self.ransackable_attributes(_auth_object = nil)
    %w[address child_dob child_family_name child_first_name child_middle_name consumed_timestep created_at current_sign_in_at current_sign_in_ip dob email
       encrypted_password family_name first_name id is_parent kin_contact_no kin_email kin_family_name kin_first_name kin_middle_name last_sign_in_at last_sign_in_ip middle_name otp_required_for_login otp_secret phone_no post_code preferred_contact_method red_cap_date_consent_signed red_cap_date_of_result_disclosure red_cap_survey_one_link red_cap_survey_one_return_code red_cap_survey_one_status red_cap_survey_two_link red_cap_survey_two_return_code red_cap_survey_two_status remember_created_at reset_password_sent_at reset_password_token sign_in_count state suburb survey_one_email_reminder_sent survey_one_email_sent survey_two_email_reminder_sent survey_two_email_sent updated_at]
  end

  def kin_details_and_child_details_on_create
    if is_parent == false
      validates_presence_of :kin_first_name, :kin_family_name
      validates_format_of :kin_email, with: Devise.email_regexp
    elsif is_parent == true
      validates_presence_of :child_first_name, :child_family_name
    end
  end

  def kin_details_and_child_details_on_update
    if is_parent == false
      validates_presence_of :kin_first_name, :kin_family_name, :kin_contact_no
      validates_format_of :kin_email, with: Devise.email_regexp
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

  def upload_redcap_details
    studies.each do |study|
      Redcap.perform(
        :user_to_import_redcap_response,
        :get_import_payload,
        record: self,
        study_name: study.name,
        expected_count: 1
      )
    end
  end
end
