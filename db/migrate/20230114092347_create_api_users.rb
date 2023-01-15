class CreateApiUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :api_users do |t|
      t.string :name
      t.string :token_digest

      t.timestamps
    end

    add_index :api_users, :name, unique: true
  end
end
