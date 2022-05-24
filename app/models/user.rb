class User < ApplicationRecord
  attr_accessor :skip_validation

  has_paper_trail
  include UserDateValidator

  has_many :reviewed_steps,
    class_name:  'StepReview',
    dependent:   :destroy

  has_many :answers,
    class_name:  'QuestionAnswer',
    dependent:   :destroy

  has_many :steps, dependent: :destroy, class_name: 'Step'

  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :family_name, :study_id, presence: true

  validates :study_id, format: {
    with: /\AA[0-4]{1}[0-9]{1}[2-4]{1}[0-9]{4}\z/,
    message: 'Please check Study ID'
  }, allow_blank: true

  validates :flagship,
    :preferred_contact_method,
    presence: true,
    on: :update,
    unless: :skip_validation

  validate :date_of_birth_in_future,
    unless: :skip_validation

  validate :kin_details_and_child_details,
    :child_date_of_birth_in_future,
    on: :update, unless: :skip_validation

  validates :terms_and_conditions, acceptance: true

  validate :check_study_code, if: -> { study_id.present? }

  accepts_nested_attributes_for :steps

  enum flagship: [
    'Acute Care Genomic Testing',
    'Acute Lymphoblastic Leukaemia',
    'Brain Malformations',
    'Cardiovascular Genetic Disorders',
    'chILDRANZ',
    'Epileptic Encephalopathy',
    'Genetic Immunology',
    'Genomic Autopsy',
    'Hereditary Cancer Syndromes (ICCon)',
    'HIDDEN Renal Genetics',
    'Intellectual Disability',
    'Leukodystrophies',
    'Mitochondrial Disorders',
    'Neuromuscular Disorders',
    'KidGen',
    'Solid Tumours'
  ]

  enum state: %w[ACT NSW NT QLD SA TAS VIC WA]
  enum preferred_contact_method: %w[Email Phone Mail]

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
end
