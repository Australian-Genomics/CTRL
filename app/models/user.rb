class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :family_name, :flagship, :study_id
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
    self.steps.find_by(number: 1)
  end

  def step_two
    self.steps.find_by(number: 2)
  end

  def step_three
    self.steps.find_by(number: 3)
  end

  def step_four
    self.steps.find_by(number: 4)
  end

  def step_five
    self.steps.find_by(number: 5)
  end

  def create_consent_step
    (1..5).each {|step_number| self.steps.create(number: step_number, accepted: false) }
  end
end