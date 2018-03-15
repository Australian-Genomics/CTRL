class AddColumnsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :middle_name, :string
    add_column :users, :family_name, :string
    add_column :users, :phone_no, :string
    add_column :users, :dob, :date
    add_column :users, :preferred_contact_method, :string, default: 'Email'
    add_column :users, :address, :string
    add_column :users, :suburb, :string
    add_column :users, :state, :string
    add_column :users, :post_code, :string
    add_column :users, :is_parent, :boolean
    add_column :users, :kin_first_name, :string
    add_column :users, :kin_middle_name, :string
    add_column :users, :kin_family_name, :string
    add_column :users, :kin_contact_no, :string
    add_column :users, :kin_email, :string
  end
end
