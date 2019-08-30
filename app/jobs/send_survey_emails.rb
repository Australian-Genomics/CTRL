class SendSurveyEmails
  include Delayed::RecurringJob
  run_every 1.day
  run_at '3:00pm'
  timezone 'Australia/Melbourne'
  queue 'send_survey_emails'
  def perform
    User.send_survey_emails
  end
end
