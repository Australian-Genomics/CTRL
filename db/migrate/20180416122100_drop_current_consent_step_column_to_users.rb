class DropCurrentConsentStepColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :current_consent_step
  end
end
