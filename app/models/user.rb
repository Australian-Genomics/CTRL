class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :family_name, :flagship, :study_id
  has_many :steps, dependent: :destroy, class_name: 'Step'
  accepts_nested_attributes_for :steps
  before_save :create_consent_step

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

  def create_consent_step
    create_step_one
    create_step_two
    create_step_three
    create_step_four
    create_step_five
  end
  
  def create_step_one
    self.steps.build(number: 1, accepted: false)
  end

  def create_step_two
    step_two = self.steps.build(number: 2, accepted: false)
    step_two.questions.build(number: 1, answer: nil)
    step_two.questions.build(number: 2, answer: nil)
    step_two.questions.build(number: 3, answer: nil)
    step_two.questions.build(number: 4, answer: nil)
    step_two.questions.build(number: 5, answer: nil)
    step_two.questions.build(number: 6, answer: nil)
    step_two.questions.build(number: 7, answer: nil)
    step_two.questions.build(number: 8, answer: nil)
    step_two.questions.build(number: 9, answer: nil)
    step_two.questions.build(number: 10, answer: nil)
    step_two.questions.build(number: 11, answer: nil)
  end
  
  def create_step_three
    step_three = self.steps.build(number: 3, accepted: false)
    step_three.questions.build(number: 1, answer: nil)
    step_three.questions.build(number: 2, answer: nil)
    step_three.questions.build(number: 3, answer: nil)
  end

  def create_step_four
    step_four = self.steps.build(number: 4, accepted: false)
    step_four.questions.build(number: 1, answer: nil)
    step_four.questions.build(number: 2, answer: nil)
    step_four.questions.build(number: 3, answer: nil)
    step_four.questions.build(number: 4, answer: nil)
    step_four.questions.build(number: 5, answer: nil)
    step_four.questions.build(number: 6, answer: nil)
  end

  def create_step_five
    step_five = self.steps.build(number: 5, accepted: false)
    step_five.questions.build(number: 1, answer: nil)
    step_five.questions.build(number: 2, answer: nil)
    step_five.questions.build(number: 3, answer: nil)
    step_five.questions.build(number: 4, answer: nil)
    step_five.questions.build(number: 5, answer: nil)
    step_five.questions.build(number: 6, answer: nil)
    step_five.questions.build(number: 7, answer: nil)
    step_five.questions.build(number: 8, answer: nil)
    step_five.questions.build(number: 9, answer: nil)
    step_five.questions.build(number: 10, answer: nil)
    step_five.questions.build(number: 11, answer: nil)
  end
end
