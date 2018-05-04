class UserMailer < ApplicationMailer
  def send_first_survey_email(user)
    @user = user
    @genetic_counsellor = @user.genetic_counsellor
    attach_image 'logo@2x.png'
    attach_image 'Rectangle.png'
    attach_image 'Group.png'

    sender = 'ctrl@australiangenomics.org.au'

    user.update(survey_one_email_sent: true)
    mail(to: "#{user.first_name} #{user.family_name} <#{user.email}>", subject: 'Australian Genomics Rare Disease Patient Survey – PART 1', sender: sender, from: sender)
  end

  def attach_image(image_name)
    attachments.inline[image_name] = File.read(File.join(Rails.root, 'app', 'assets', 'images', image_name))
  end
end
