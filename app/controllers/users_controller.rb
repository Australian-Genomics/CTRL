class UsersController < ApplicationController
  def create
    @user = User.new(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to user_path
    else
      render_status :error
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :family_name, :middle_name, :dob, :email, :address, :phone_no, :preferred_contact_method)
  end
end
