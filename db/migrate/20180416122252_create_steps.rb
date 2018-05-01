class CreateSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :steps do |t|
      t.integer :number
      t.boolean :accepted
      t.references :user
      t.timestamps
    end
  end
end
