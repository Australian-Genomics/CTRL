class Question < ApplicationRecord
  has_paper_trail

  belongs_to :step

  enum answer: %w[false true not_sure]

  def check_box_checked?(default_value)
    answer ? answer.eql?('true') : default_value
  end

  def radio_button_checked?(default_value)
    if answer
      return answer if answer.eql?('not_sure')

      answer.eql?('true')
    else
      default_value
    end
  end

  def answer_value
    Question.answers[answer]
  end
end
