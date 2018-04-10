class AddStudyIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :study_id, :text
  end
end
