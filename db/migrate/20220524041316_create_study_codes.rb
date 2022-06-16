class CreateStudyCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :study_codes do |t|
      t.string :title
      t.timestamps
    end
  end
end
