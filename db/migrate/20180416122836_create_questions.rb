class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.integer :number
      t.boolean :answer
      t.references :steps
      t.timestamps
    end
  end
end
