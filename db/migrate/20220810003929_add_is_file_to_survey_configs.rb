class AddIsFileToSurveyConfigs < ActiveRecord::Migration[5.2]
  def change
    add_column :survey_configs, :is_file, :boolean
  end
end
