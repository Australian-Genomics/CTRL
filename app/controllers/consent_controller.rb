class ConsentController < ApplicationController
  before_action :authenticate_user!

  def step_one; end

  def step_two
    @user = User.new
    @user.save
  end

  def step_three; end

end
