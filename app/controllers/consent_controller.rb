class ConsentController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def step_one; end

  def step_two; end

  def step_three; end

  def confirm_answers; end

  def review_answers; end
end
