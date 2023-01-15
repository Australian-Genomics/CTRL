class AddIndexToUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :study_id, unique: true
  end
end
