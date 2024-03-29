class CredentialsController < ApplicationController
  def request_otp
    user = User.find_by_email(params[:user][:email])

    if user&.valid_password?(params[:user][:password])
      user.otp_required_for_login = OTP_ENABLED

      user.otp_secret = User.generate_otp_secret

      OneTimePasswordMailer.send_one_time_password(user).deliver_now

      user.skip_validation = true
      user.save!

      render json: { success: true }
    else
      render json: { success: false }, status: :unauthorized
    end
  end
end
