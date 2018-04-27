class AddDeafultValueInAnswerToQuestion < ActiveRecord::Migration[5.2]
  def change
    change_column :questions, :answer, :integer, default: 0
  end
end
