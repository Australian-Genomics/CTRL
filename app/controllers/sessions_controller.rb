class Users::SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  def create
    super do
      user_session[:study_name] = 'default'
    end
  end
end
