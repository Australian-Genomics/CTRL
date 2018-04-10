class AddChildColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :child_first_name, :string
    add_column :users, :child_middle_name, :string
    add_column :users, :child_family_name, :string
    add_column :users, :child_dob, :date
  end
end
