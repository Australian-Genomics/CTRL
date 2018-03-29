class ConsentController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def step_one
    if current_user.update(current_consent_step: 0)
      render 'step_one.html.erb'
    else
      redirect_to :back
    end
  end

  def step_two
    if current_user.update(current_consent_step: 1)
      render 'step_two.html.erb'
    else
      redirect_to :back
    end
  end

  def step_three
    if current_user.update(current_consent_step: 2)
      render 'step_three.html.erb'
    else
      redirect_to :back
    end
  end

  def step_four
    if current_user.update(current_consent_step: 3)
      render 'step_four.html.erb'
    else
      redirect_to :back
    end
  end

  def step_five
    if current_user.update(current_consent_step: 4)
      render 'step_five.html.erb'
    else
      redirect_to :back
      end
  end

  def confirm_answers; end

  def review_answers; end
end
