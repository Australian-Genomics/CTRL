class UserMailer < ApplicationMailer
  def send_first_survey_email(user)
    @user = user
    @genetic_counsellor = @user.genetic_counsellor
    attachments.inline['logo@2x.png'] = File.read(File.join(Rails.root, "app", "assets", "images", "logo@2x.png"))
    attachments.inline['Rectangle.png'] = File.read(File.join(Rails.root, "app", "assets", "images", "Rectangle.png"))
    attachments.inline['Group.png'] = File.read(File.join(Rails.root, "app", "assets", "images", "Group.png"))

    sender = 'ctrl@australiangenomics.org.au'

    user.update(survey_one_email_sent: true)
    mail(to: "#{user.first_name} #{user.family_name} <#{user.email}>", subject: 'Australian Genomics Rare Disease Patient Survey – PART 1', sender: sender, from: sender)
  end
end
