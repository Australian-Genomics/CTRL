class ContactMailer < ApplicationMailer
  def send_contact_us_email(user, content, admin = true)
    @user = user
    @content = content
    @to_admin = admin
    mail_to, subject = find_details

    mail(
      to: mail_to,
      subject: subject,
      sender: SENDER_EMAIL,
      from: SENDER_EMAIL
    )
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
