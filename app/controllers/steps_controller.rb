class StepsController < ApplicationController

  def update
    @step = Step.find(params[:id])
    @step.update(step_params)
    if params[:registration_step_two]
      redirect_to step_two_path(registration_step_two: true)
    elsif params[:registration_step_three]
      if params[:step][:questions_attributes].select {|x| params[:step][:questions_attributes][x][:answer] == '0'}.empty?
        redirect_to confirm_answers_path
      else
        redirect_to review_answers_path
      end
    elsif params[:registration_step_four]
      redirect_to step_four_path(registration_step_four: true)
    elsif params[:registration_step_five]
      redirect_to step_five_path(registration_step_five: true)
    else
      redirect_to dashboard_index_path
    end
  end

  private

  def step_params
    params.require(:step).permit(:accepted, questions_attributes: [:answer, :id, :question_id, :user_id])
  end
end
