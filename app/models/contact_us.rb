class ContactUs
  attr_accessor :message, :user

  def initialize(user, message)
    @user = user
    @message = message
  end

  def send_message
    to_admin = [true, false]
    # send email to both admin and user
    to_admin.each do |admin|
      ContactMailer.send_contact_us_email(@user, @message, admin).deliver
    end
  end
end
