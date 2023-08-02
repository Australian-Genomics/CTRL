class CredentialsController < ApplicationController
  def request_otp
    user = User.find_by_email(params[:user][:email])

    if user && user.valid_password?(params[:user][:password])
      user.otp_secret = User.generate_otp_secret

      # TODO
      pp user.current_otp

      user.skip_validation = true
      user.save!

      render json: { success: true }
    else
      render json: { success: false }, status: :unauthorized
    end
  end
end
