class RegistrationsController < Devise::RegistrationsController
  include NextOfKinRegistrationValidator

  def initialize
    super
    @next_of_kin_needed_to_register = next_of_kin_needed_to_register?
  end

  def new
    @user = User.new
    render 'new'
  end

  protected

  def after_sign_up_path_for(_resource)
    consent_form_path
  end
end
