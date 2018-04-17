class Step < ApplicationRecord
  belongs_to :user
  attr_accessor :user
  has_many :questions, dependent: :destroy
  after_save :save_answers

  def save_answers
    # 11.times {self.questions.create(number: 1, answer: nil)}

  end
end
