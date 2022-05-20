class CreateSurveyConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_configs do |t|
      t.string :name
      t.string :value
      t.string :key
      t.timestamps
    end
  end
end
