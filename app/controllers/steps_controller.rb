class StepsController < ApplicationController

  def update
    @step = Step.find(params[:id])
    @step.update(step_params)
    if params[:registration_step_two]
      redirect_to step_two_path
    else
      redirect_to dashboard_index_path
    end
  end

  private

  def step_params
    params.require(:step).permit(:accepted, questions_attributes: [:answer, :id])
  end
end
