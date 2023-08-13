class Users::SessionsController < Devise::SessionsController
  def create
    # Get the study_name from params
    study_name = params[:user][:study_name]

    # Validate study_name
    if Study.exists?(name: study_name)
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)

      user_session['study_name'] = study_name

      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      # Invalid study_name, do not proceed with login
      # You may want to set a flash message to inform the user
      set_flash_message! :alert, :invalid_study_name
      redirect_to new_session_path(resource_name)
    end
  end
end
