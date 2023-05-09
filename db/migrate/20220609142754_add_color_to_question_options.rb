class AddColorToQuestionOptions < ActiveRecord::Migration[5.2]
  def change
    add_column :question_options, :color, :string, default: '#02b0db'
  end
end
