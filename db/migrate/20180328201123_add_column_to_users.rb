class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :steps, :string
  end
end
