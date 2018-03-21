class PasswordsController < Devise::PasswordsController
  def sent; end

  protected

  def after_sending_reset_password_instructions_path_for(_resource_name)
    passwords_sent_path
  end
end
