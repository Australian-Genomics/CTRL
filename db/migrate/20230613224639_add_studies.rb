class AddStudies < ActiveRecord::Migration[7.0]
  def change
    create_table :studies do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :participant_id_format, null: false
    end

    create_join_table :studies, :users do |t|
      t.index :study_id
      t.index :user_id

      t.string :participant_id, null: false
    end

    add_column :consent_steps, :study_id, :integer
    add_foreign_key :consent_steps, :studies

    add_column :glossary_entries, :study_id, :integer
    add_foreign_key :glossary_entries, :studies

    add_column :api_users, :study_id, :integer
    add_foreign_key :api_users, :studies

    drop_table :participant_id_formats
  end
end
