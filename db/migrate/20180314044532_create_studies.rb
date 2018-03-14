class CreateStudies < ActiveRecord::Migration[5.2]
  def change
    create_table :studies do |t|
      t.string :flagship
      t.string :study_id

      t.timestamps
    end
  end
end
