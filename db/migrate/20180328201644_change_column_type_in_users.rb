class ChangeColumnTypeInUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :flagship, 'integer USING flagship::integer'
    change_column :users, :current_consent_step, 'integer USING current_consent_step::integer'
  end
end
