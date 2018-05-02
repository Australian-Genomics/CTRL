class UserMailer < ApplicationMailer
  def send_first_survey_email(user)
    @user = user
    @genetic_counsellor = @user.genetic_counsellor

    sender = 'ctrl@australiangenomics.org.au'

    user.update(survey_one_email_sent: true)
    mail(to: "#{user.first_name} #{user.family_name} <#{user.email}>", subject: 'Australian Genomics Rare Disease Patient Survey – PART 1', sender: sender, from: sender)
  end
end
