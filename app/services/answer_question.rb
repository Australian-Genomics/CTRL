class AnswerQuestion < ApplicationService
  attr_accessor :answer_params, :user
  attr_reader :question_id, :user_answer

  def initialize(answer_params, user)
    @answer_params = answer_params
    @user = user
    @question_id = answer_params[:consent_question_id]
    @user_answer = answer_params[:answer]
    @question_type = answer_params[:question_type]
  end

  def call
    if @question_type == 'multiple checkboxes'
      existing_answers = find_question_answers(question_id)
      multiple_answers = answer_params[:multiple_answers]
      existing_answers.destroy_all

      multiple_answers.each do |ans|
        save_answer(ans, question_id)
      end
    else
      existing_answer = find_question_answer(question_id)
      if existing_answer.present?
        existing_answer.update!(answer: user_answer)
      else
        save_answer(user_answer, question_id)
      end
    end
  end

  private

  def find_question_answer(question_id)
    QuestionAnswer.find_by(
      user: user,
      consent_question_id: question_id
    )
  end

  def find_question_answers(question_id)
    QuestionAnswer.where(
      user: user,
      consent_question_id: question_id
    )
  end

  def save_answer(answer, question_id)
    QuestionAnswer.create!(
      user: user,
      consent_question: find_question(question_id),
      answer: answer
    )
  end

  def find_question(question_id)
    ConsentQuestion.find(question_id)
  end
end
