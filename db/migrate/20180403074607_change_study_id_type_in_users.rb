class ChangeStudyIdTypeInUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :study_id, :string
  end
end
