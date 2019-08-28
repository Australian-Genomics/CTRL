class SendSurveyEmails
  include Delayed::RecurringJob
  run_every 5.min
  # run_at '9:00am'
  timezone 'Australia/Melbourne'
  queue 'send_survey_emails'
  def perform
    User.send_survey_emails
  end
end
