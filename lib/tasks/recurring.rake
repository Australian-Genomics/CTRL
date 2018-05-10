namespace :recurring do
  desc "Adds a rake tast for sending survey emails"
  task check_redcap_and_send_emails: :environment do
    SendSurveyEmails.schedule!
  end

end