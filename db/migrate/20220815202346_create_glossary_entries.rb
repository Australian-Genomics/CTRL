class CreateGlossaryEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :glossary_entries do |t|
      t.string :term
      t.string :definition

      t.timestamps
    end
  end
end
