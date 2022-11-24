class CreateUserColumnToRedcapFieldMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :user_column_to_redcap_field_mappings do |t|
      t.string :user_column, null: false
      t.string :redcap_field, null: false
      t.string :redcap_event_name
    end

    add_index(:user_column_to_redcap_field_mappings, :user_column, unique: true, name: 'uctrfm_user_column_index')
    add_index(:user_column_to_redcap_field_mappings,  [:redcap_field, :redcap_event_name], unique: true, name: 'uctrfm_redcap_index')
  end
end
