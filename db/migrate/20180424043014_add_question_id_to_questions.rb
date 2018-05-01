class AddQuestionIdToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :question_id, :integer
    add_reference :questions, :user
  end
end
