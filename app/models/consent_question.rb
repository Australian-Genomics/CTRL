class ConsentQuestion < ApplicationRecord
  belongs_to :consent_group

  has_many :answers,
    class_name:  'QuestionAnswer',
    dependent:   :destroy

  has_many :question_options
end
