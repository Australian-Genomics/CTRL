class RenameStudyId < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :study_id, :participant_id
  end
end
