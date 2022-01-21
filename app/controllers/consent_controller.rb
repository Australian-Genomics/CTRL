class ConsentController < ApplicationController
  before_action :authenticate_user!
  before_action :find_steps, only: :index

  def edit; end

  def index
    render 'index.json.jbuilder'
  end

  def update
    mark_step_as_reviewed(params[:consent_step_id])
    params[:answers].each { |answer| create_or_update_existing_answer(answer) }
  end

  private

  def find_steps
    @consent_steps = ConsentStep.ordered
  end

  def mark_step_as_reviewed(step_id)
    StepReview.find_or_create_by(
      user: current_user,
      consent_step_id: step_id
    )
  end

  def create_or_update_existing_answer(answer)
    existing_answer = find_question_answer(answer[:consent_question_id])
    if existing_answer.present?
      existing_answer.update!(answer: answer[:answer])
    else
      save_answer(answer)
    end
  end

  def find_question_answer(question_id)
    QuestionAnswer.find_by(
      user: current_user,
      consent_question_id: question_id
    )
  end

  def save_answer(answer)
    QuestionAnswer.create!(
      user: current_user,
      consent_question: find_question(answer[:consent_question_id]),
      answer: answer[:answer]
    )
  end

  def find_question(question_id)
    ConsentQuestion.find(question_id)
  end
end
