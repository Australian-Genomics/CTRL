class ChangeANswerTypeToQuestions < ActiveRecord::Migration[5.2]
  def change
    change_column :questions, :answer, 'integer USING answer::integer'
  end
end
