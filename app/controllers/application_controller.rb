class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit

  protected

  def configure_permitted_parameters
    added_attrs = %i[first_name family_name flagship dob study_id email password password_confirmation remember_me terms_and_conditions]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def after_sign_in_path_for(resource)
    if resource.class == AdminUser
      admin_root_path
    else
      dashboard_index_path
    end
  end
end
