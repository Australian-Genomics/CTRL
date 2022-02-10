class CreateQuestionOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :question_options do |t|
      t.string :value
      t.references :consent_question, foreign_key: true
    end
  end
end
