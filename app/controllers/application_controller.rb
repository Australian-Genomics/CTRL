require 'base64'

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit

  def logo
    logo_png_binary = self.logo_png_binary
    args = {type: 'image/png', disposition: 'inline'}

    if logo_png_binary
      send_data logo_png_binary, args
    else
      send_file Rails.root.join('app', 'assets', 'images', 'australian-genomics-logo.png'), args
    end
  end

  protected

  def logo_png_binary
    sc = SurveyConfig.find_by(name: APPLICATION_LOGO_PNG)
    begin
      (sc&.value and sc&.value != "") ? Base64.strict_decode64(sc&.value) : nil
    rescue ArgumentError
      nil
    end
  end

  def configure_permitted_parameters
    added_attrs = %i[
      first_name
      family_name
      dob
      study_id
      kin_first_name
      kin_family_name
      kin_email
      is_parent
      child_first_name
      child_middle_name
      child_family_name
      child_dob
      email
      password
      password_confirmation
      remember_me
      terms_and_conditions
    ]
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
