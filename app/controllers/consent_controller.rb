class ConsentController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def step_one
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

  def goto_step
    # if current_user.update(current_consent_step: params[:registration_step_two].to_i)
      if params[:registration_step_two]
        case (params[:registration_step_two].to_i)
        when 1
          render 'step_two.html.erb'
        when 2
          render 'step_three.html.erb'
        when 3
          render 'step_four.html.erb'
        when 4
          render 'step_five.html.erb'
        end
      elsif params[:save]
        current_user.update(current_consent_step: 4)
        redirect_to dashboard_index_path
      end
  end

  def confirm_answers;
  end

  def review_answers;
  end

end