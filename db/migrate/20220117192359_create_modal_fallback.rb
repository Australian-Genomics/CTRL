class CreateModalFallback < ActiveRecord::Migration[5.2]
  def change
    create_table :modal_fallbacks do |t|
      t.text :description
      t.string :cancel_btn
      t.string :review_answers_btn
      t.text :small_note
      t.references :consent_step, foreign_key: true

      t.timestamps
    end
  end
end
