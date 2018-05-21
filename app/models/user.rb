class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :family_name, :study_id
  has_many :steps, dependent: :destroy, class_name: 'Step'
  accepts_nested_attributes_for :steps
  after_create :create_consent_step

  enum flagship: ['Acute Care Genomic Testing',
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
                  'Renal Genetic Disorders',
                  'Solid Tumours']

  def step_one
    steps.find_by(number: 1)
  end

  def step_two
    steps.find_by(number: 2)
  end

  def step_three
    steps.find_by(number: 3)
  end

  def step_four
    steps.find_by(number: 4)
  end

  def step_five
    steps.find_by(number: 5)
  end

  def create_consent_step
    (1..5).each { |step_number| steps.create(number: step_number, accepted: false) }
  end

  def genetic_counsellor
    gc = find_in_first_group_of_genetic_counsellors
    gc = find_in_second_group_of_genetic_counsellors if gc.blank?
    gc
  end

  def find_in_first_group_of_genetic_counsellors
    case study_id
    when /^A0134(.)+/
      { name: 'Ella Wilkins', site: 'RCH', phone: '03 9936 6333', email: 'ella.wilkins@vcgs.org.au' }
    when /^A1534(.)+/
      { name: 'Lindsay Fowles', site: 'RBWH', phone: '07 3646 1686 (M,T,W,F) 07 3646 0254 (Th)', email: 'Lindsay.Fowles@health.qld.gov.au' }
    when /^(A0434|A1434)(.)+/
      { name: 'Gayathri Parasivam', site: 'SCHN', phone: '02 9845 1225', email: 'gayathri.parasivam@health.nsw.gov.au' }
    when /^A0132(.)+/
      { name: 'Michelle de Silva', site: 'RCH', phone: '03 9936 6109', email: 'michelle.desilva@mcri.edu.au' }
    end
  end

  def find_in_second_group_of_genetic_counsellors
    case study_id
    when /^A0432(.)+/
      { name: 'Kirsten Boggs', site: 'SCHN', phone: '02 9382 5616 (Randwick)', email: 'kirsten.boggs@health.nsw.gov.au' }
    when /^A1432(.)+/
      { name: 'Kirsten Boggs', site: '', phone: '02 9845 3273 (Westmead)', email: 'kirsten.boggs@health.nsw.gov.au' }
    when /^A1532(.)+/
      { name: 'Melanie Tom', site: 'RBWH', phone: '07 3636 0254', email: 'melanie.tom@health.qld.gov.au' }
    else
      { name: '', site: '', phone: '', email: 'australian.genomics@mcri.edu.au' }
    end
  end

  def self.send_survey_emails
    update_dates_from_redcap
    update_survey_one_link_from_redcap
    update_survey_one_code_from_redcap
    update_survey_one_status_from_redcap

    send_survey_one_emails
  end

  def self.send_survey_one_emails
    users_needing_email_sent = User.where('red_cap_date_consent_signed <= ?', Date.today - 1.week).where(survey_one_email_sent: false).where.not(red_cap_survey_one_link: nil)

    users_needing_email_sent.each do |user|
      UserMailer.delay.send_first_survey_email(user)
    end
  end

  def self.update_survey_one_status_from_redcap
    users_with_missing_survey_one_status = User.where(red_cap_survey_one_status: nil)

    users_with_missing_survey_one_status.each do |user|
      status = RedCapManager.get_survey_one_status(user.study_id)
      user.update(red_cap_survey_one_status: status) if status.present?
    end
  end

  def self.update_survey_one_code_from_redcap
    users_with_missing_survey_one_code = User.where(red_cap_survey_one_return_code: nil)

    users_with_missing_survey_one_code.each do |user|
      survey_code = RedCapManager.get_survey_one_return_code(user.study_id)
      user.update(red_cap_survey_one_return_code: survey_code) if survey_code.present?
    end
  end

  def self.update_survey_one_link_from_redcap
    users_with_missing_survey_one_link = User.where(red_cap_survey_one_link: nil)

    users_with_missing_survey_one_link.each do |user|
      survey_link = RedCapManager.get_survey_one_link(user.study_id)
      user.update(red_cap_survey_one_link: survey_link) if survey_link.present?
    end
  end

  def self.update_dates_from_redcap
    users_with_missing_dates = User.where(red_cap_date_consent_signed: nil)

    users_with_missing_dates.each do |user|
      dates = RedCapManager.get_consent_and_result_dates(user.study_id)
      update_consent_signed_date(dates, user)
    end
  end

  def self.update_result_disclosure_date(dates, user)
    user.update(red_cap_date_of_result_disclosure: dates['red_cap_date_of_result_disclosure']) if dates.present? && dates['red_cap_date_of_result_disclosure'].present?
  end

  def self.update_consent_signed_date(dates, user)
    user.update(red_cap_date_consent_signed: dates['ethic_cons_sign_date']) if dates.present? && dates['ethic_cons_sign_date'].present?
  end
end
