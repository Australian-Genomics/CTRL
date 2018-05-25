class UsersController < ApplicationController
  DOB_REGEX = /\A\d{2}-\d{2}-\d{4}\z/

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path
    else
      check_dob_format if @user.errors.include? :dob
      render 'users/edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :family_name, :middle_name, :dob, :flagship, :study_id, :email,
                                 :address, :suburb, :state, :is_parent, :post_code, :phone_no, :preferred_contact_method,
                                 :kin_first_name, :kin_middle_name, :kin_family_name, :kin_email, :kin_contact_no,
                                 :child_first_name, :child_middle_name, :child_family_name, :child_dob)
  end

  def check_dob_format
    dob = user_params[:dob]

    if !dob.blank? && @user.errors.added?(:dob, :blank)
      @user.errors.delete(:dob)
      @user.errors.add(:dob, 'Invalid format') unless dob =~ DOB_REGEX
    end
  end
end
