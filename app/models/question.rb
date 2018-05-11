class Question < ApplicationRecord
  enum answer: %w[false true not_sure]

  def checked?(default_value)
    answer.eql?('not_sure') ? default_value : answer.eql?('true')
  end
end
