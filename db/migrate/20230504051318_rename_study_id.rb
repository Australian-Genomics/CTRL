class RenameStudyId < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :study_id, :participant_id

    rename_column :study_codes, :title, :participant_id_format
    rename_table :study_codes, :participant_id_formats
  end
end
