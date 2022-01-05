class SurveyQuestion < ApplicationRecord
  before_create :set_question_id

  validates :default_value,
    inclusion: {
      in: %w(true false not_sure),
      message: "
        only true, false or not_sure are permitted
      "
    }
end
