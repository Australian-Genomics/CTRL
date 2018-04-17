class Step < ApplicationRecord
  has_many :questions, dependent: :destroy
  after_save :save_answers

  def save_answers
    self.questions.create(number: 1, answer: nil)
    self.questions.create(number: 2, answer: nil)
    self.questions.create(number: 3, answer: nil)
    self.questions.create(number: 4, answer: nil)
    self.questions.create(number: 5, answer: nil)
    self.questions.create(number: 6, answer: nil)
    self.questions.create(number: 7, answer: nil)
    self.questions.create(number: 8, answer: nil)
    self.questions.create(number: 9, answer: nil)
    self.questions.create(number: 10, answer: nil)
    self.questions.create(number: 11, answer: nil)
  end
end
