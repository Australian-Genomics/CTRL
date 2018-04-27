class Step < ApplicationRecord
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions

  def build_question_for_step(step, user_id)
    question_arr = case step
                   when :two
                     (1..11)
                   when :three
                     (12..14)
                   when :four
                     (15..20)
                   when :five
                     (21..31)
                   end
    question_arr.each do |time|
      questions.build(question_id: time, user_id: user_id)
    end
  end
end
