class CreateSurveyQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_questions do |t|
      t.string :locale, default: 'en'
      t.integer :order

      t.integer :step
      t.integer :question_id

      t.text :question
      t.text :description
      t.string :default_value

      t.string :redcap_field

      t.timestamps null: false
    end

    add_index :survey_questions, :locale
  end
end
