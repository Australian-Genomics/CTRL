class StepsController < ApplicationController

  def update
    @step = Step.find(params[:id])
    @step.update(step_params)
    if params[:registration_step_two]
      redirect_to step_two_path(registration_step_two: true)
    elsif params[:registration_step_three]
      redirect_to step_three_path(registration_step_three: true)
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
    params.require(:step).permit(:accepted, questions_attributes: [:answer, :id])
  end
end
