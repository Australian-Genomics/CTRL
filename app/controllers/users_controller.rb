class UsersController < ApplicationController
  def create
    @user = User.new(params[:user])
  end
end
