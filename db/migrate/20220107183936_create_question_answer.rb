class CreateQuestionAnswer < ActiveRecord::Migration[5.2]
  def change
    create_table :question_answers do |t|
      t.integer :consent_question_id
      t.integer :user_id
      t.string :answer
    end

    add_index :question_answers, :user_id
    add_index :question_answers, :consent_question_id
  end
end
