class CreateGlossaryEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :glossary_entries do |t|
      t.string :term
      t.text :definition

      t.timestamps
    end
  end
end
