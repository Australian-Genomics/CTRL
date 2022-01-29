class ConsentController < ApplicationController
  before_action :authenticate_user!
  before_action :find_steps, only: :index

  def edit; end

  def index
    render 'index.json.jbuilder'
  end

  def update
    mark_step_as_reviewed(params[:consent_step_id])
    params[:answers].each { |answer| answer_question(answer) }
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

  def answer_question(answer)
    AnswerQuestion.call(answer, current_user)
  end
end
