class ChangeStepAndPreferredContactMethodTypeToUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :state, :integer, using: 'state::integer'
    change_column :users, :preferred_contact_method, :string, default: nil

    User.where(preferred_contact_method: 'Email').update_all(preferred_contact_method: 0)

    change_column :users, :preferred_contact_method, :integer, using: 'preferred_contact_method::integer'
  end

end
