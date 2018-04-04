class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :family_name, :middle_name, :dob, :flagship, :study_id, :email, :address, :suburb, :state, :post_code, :phone_no, :preferred_contact_method)
  end
end
