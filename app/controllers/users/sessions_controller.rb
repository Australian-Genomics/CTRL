class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)

    # TODO: Once front end is implemented, use: params[:user][:study_name]
    user_session['study_name'] = 'default'

    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end
end
