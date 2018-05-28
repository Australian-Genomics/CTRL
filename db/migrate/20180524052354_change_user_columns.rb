class ChangeUserColumns < ActiveRecord::Migration[5.2]
  def change
    User.all.update_all(state: 6)
    change_column :users, :state, :integer, using: 'state::integer'

    remove_column :users, :preferred_contact_method
    add_column :users, :preferred_contact_method, :integer, default: 0
  end
end
