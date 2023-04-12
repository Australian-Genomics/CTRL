class AddRedcapEventNameToConsentQuestion < ActiveRecord::Migration[5.2]
  def change
    add_column :consent_questions, :redcap_event_name, :string
  end
end
