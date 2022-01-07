class ConsentGroup < ApplicationRecord
  belongs_to :consent_step

  has_many :consent_questions, dependent: :destroy
end
