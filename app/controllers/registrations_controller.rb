class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    step_one_path
  end
end