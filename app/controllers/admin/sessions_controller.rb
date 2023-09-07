module Admin
  class SessionsController < ActiveAdmin::Devise::SessionsController
    layout 'active_admin_logged_out'
    helper ActiveAdmin::ViewHelpers

    before_action :configure_sign_in_params, only: [:create]

    def create
      admin_user = AdminUser.find_by(email: sign_in_params[:email])
      is_valid, error = authenticate(
        admin_user,
        sign_in_params[:password],
        sign_in_params[:otp_attempt]
      )
      if is_valid
        flash.discard
        sign_in(admin_user, event: :authentication)
        redirect_to admin_dashboard_path
      else
        flash[:error] = error
        @admin_user = AdminUser.find_by(email: sign_in_params[:email]) || AdminUser.new
        render :new
      end
    end

    private

    def authenticate(admin_user, password, otp_attempt)
      return [false, 'Invalid email or password'] unless
        admin_user.present? && admin_user.valid_password?(password)

      return [true, ''] unless admin_user.otp_required_for_login

      return [false, 'Invalid one-time password'] unless
        admin_user.validate_and_consume_otp!(otp_attempt)

      [true, '']
    end

    def sign_in_params
      if params[:admin_user]
        super.merge(otp_attempt: params[:admin_user][:otp_attempt])
      else
        super
      end
    end

    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
    end
  end
end
