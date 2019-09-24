class ContactMailer < ApplicationMailer
  DEFAULT_SENDER = 'ctrl@australiangenomics.org.au'.freeze

  def send_contact_us_email(user, content, admin = true)
    @user = user
    @content = content
    @to_admin = admin
    sender = DEFAULT_SENDER
    mail_to, subject = find_details

    mail(to: mail_to, subject: subject, sender: sender, from: sender)
  end

  private

  def find_details
    if @to_admin
      receiver = ENV['CTRL_ADMIN_EMAIL'] || 'australian.genomics@mcri.edu.au'
      mail_to = "CTRL administrator <#{receiver}>"
      subject = "New CTRL contact form submission - from #{@user.first_name} #{@user.family_name}"
    else
      mail_to = "#{@user.first_name} #{@user.family_name} <#{@user.email}>"
      subject = 'A copy of your message submitted to CTRL Administration Team'
    end
    [mail_to, subject]
  end
end
