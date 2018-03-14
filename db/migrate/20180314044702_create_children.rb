class CreateChildren < ActiveRecord::Migration[5.2]
  def change
    create_table :children do |t|
      t.string :first_name
      t.string :middle_name
      t.string :family_name
      t.string :dob

      t.timestamps
    end
  end
end
