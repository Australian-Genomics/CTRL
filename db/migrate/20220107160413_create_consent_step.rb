class CreateConsentStep < ActiveRecord::Migration[5.2]
  def change
    create_table :consent_steps do |t|
      t.integer :order

      t.string :title
      t.text :description
      t.text :popover

      t.timestamps null: false
    end

    add_index :consent_steps, :order, unique: true
  end
end
