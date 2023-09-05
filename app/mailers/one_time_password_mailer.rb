class OneTimePasswordMailer < ApplicationMailer
  def send_one_time_password(resource)
    @resource = resource

    attach_image 'australian-genomics-logo.png'
    attach_image 'Group.png'

    mail(to: @resource.email, subject: 'Your One-time Password')
  end

  def attach_image(image_name)
    attachments.inline[image_name] = File.read(File.join(Rails.root, 'app', 'assets', 'images', image_name))
  end
end
