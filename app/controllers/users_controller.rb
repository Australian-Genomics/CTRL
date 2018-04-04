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
    params.require(:user).permit(:first_name, :family_name, :middle_name, :dob, :flagship, :study_id, :email,
                                 :address, :suburb, :state, :is_parent, :post_code, :phone_no, :preferred_contact_method,
                                 :kin_first_name, :kin_middle_name, :kin_family_name, :kin_email, :kin_contact_no,
                                 :child_first_name, :child_middle_name, :child_family_name, :child_dob)
  end
end
