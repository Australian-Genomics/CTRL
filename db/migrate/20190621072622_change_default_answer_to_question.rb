class ChangeDefaultAnswerToQuestion < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:questions, :answer, from: 2, to: nil)
  end
end
