class SendDailyConsentChangesEmailToMatilda
  include Delayed::RecurringJob
  run_every 1.day
  run_at '1:00am'
  timezone 'Australia/Melbourne'
  queue 'send_daily_consent_changes_email_to_matilda'
  def perform
    UserMailer.send_daily_consent_email_to_matilda.deliver
  end
end
