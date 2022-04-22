class AddIsPublishedToConsentQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :consent_questions, :is_published, :boolean, default: true
  end
end
