class Step < ApplicationRecord
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions

  def build_question_for_step(user_id)
    range_of_values_for(number).each do |time|
      questions.build(question_id: time, user_id: user_id)
    end
  end

  def range_of_values_for(step)
    case step
    when 2
      (1..11)
    when 3
      (12..14)
    when 4
      (15..20)
    when 5
      (21..31)
    end
  end
end
