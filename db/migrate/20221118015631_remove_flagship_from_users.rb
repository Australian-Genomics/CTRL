class RemoveFlagshipFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :flagship, :integer
  end
end
