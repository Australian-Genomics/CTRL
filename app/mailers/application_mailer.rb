class ApplicationMailer < ActionMailer::Base
  default from: SENDER_EMAIL
  layout 'mailer'
end
