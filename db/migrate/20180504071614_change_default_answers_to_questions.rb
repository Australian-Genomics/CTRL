class ChangeDefaultAnswersToQuestions < ActiveRecord::Migration[5.2]
  def change
    change_column :questions, :answer, :integer, default: 2
  end
end
