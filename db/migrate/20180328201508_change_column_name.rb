class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :steps, :current_consent_step
  end
end
