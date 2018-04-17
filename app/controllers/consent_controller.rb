class ConsentController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def step_one
    @user = User.new
    @user.steps.build(step_params)
    render 'step_one.html.erb'
    # if params[:next]
    #   redirect_to step_two_path
    # elsif params[:save]
    #   redirect_to dashboard_index_path
    # end
  end

  def step_two
    render 'step_two.html.erb'
  end

  def step_three
    render 'step_three.html.erb'
  end

  def step_four
    render 'step_four.html.erb'
  end

  def step_five
    render 'step_five.html.erb'
  end

  def confirm_answers;
  end

  def review_answers;
  end

  private

  def step_params
    params.permit({steps_attributes: [:number,:accpeted]})
  end

end