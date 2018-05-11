class Question < ApplicationRecord
  enum answer: %w[false true not_sure]

  def checked?(default_value)
    if [11, 14].include? question_id
      'false'
    elsif answer == 'not_sure'
      default_value
    else
      answer.eql? 'true'
    end
  end
end
