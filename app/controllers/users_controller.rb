class UsersController < ApplicationController
  before_action :find_user, only: %i[show edit update]

  def show
    @active_tab = 'profile'
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path
    else
      render 'users/edit'
    end
  end

  private

  def find_user
    @user = current_user
    if @user
      @study_user = @user.study_users.find_by(
        study: Study.find_by(name: 'default')
      )
    end

    redirect_to root_path unless @user
  end

  def user_params
    params.require(:user).permit(:first_name, :family_name, :middle_name, :dob, :email,
                                 :address, :suburb, :state, :is_parent, :post_code, :phone_no, :preferred_contact_method,
                                 :kin_first_name, :kin_middle_name, :kin_family_name, :kin_email, :kin_contact_no,
                                 :child_first_name, :child_middle_name, :child_family_name, :child_dob,
                                 study_users_attributes: %i[id participant_id])
  end
end
