class CreateConsentGroup < ActiveRecord::Migration[5.2]
  def change
    create_table :consent_groups do |t|
      t.integer :order
      t.references :consent_step, foreign_key: true

      t.string :header

      t.timestamps
    end

    add_index :consent_groups, :order
  end
end
