class CreateConsentQuestion < ActiveRecord::Migration[5.2]
  def change
    create_table :consent_questions do |t|
      t.integer :order
      t.references :consent_group, foreign_key: true

      t.text :question
      t.text :description

      t.string :redcap_field

      t.string :default_answer
      t.string :question_type

      t.string :answer_choices_position, default: 'right'

      t.timestamps
    end

    add_index :consent_questions, :order
  end
end
