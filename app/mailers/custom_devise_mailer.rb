class CustomDeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  def reset_password_instructions(record, token, opts = {})
    opts[:subject] = 'Reset Password Instructions'
    attach_image 'logo@2x.png'
    attach_image 'Rectangle.png'
    attach_image 'Group.png'

    super
  end

  def attach_image(image_name)
    attachments.inline[image_name] = File.read(File.join(Rails.root, 'app', 'assets', 'images', image_name))
  end
end
