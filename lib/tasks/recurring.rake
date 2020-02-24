namespace :recurring do
  desc "Adds a rake task for sending survey emails"
  task check_redcap_and_send_emails: :environment do
    SendSurveyEmails.schedule!
  end

  desc "Adds a rake task for sending survey emails"
  task send_consent_changes_email_to_matilda: :environment do
    SendDailyConsentChangesEmailToMatilda.schedule!
  end
end