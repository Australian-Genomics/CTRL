class CreateStepReview < ActiveRecord::Migration[5.2]
  def change
    create_table :step_reviews do |t|
      t.integer :user_id
      t.integer :consent_step_id

      t.timestamps
    end

    add_index :step_reviews, :user_id
    add_index :step_reviews, :consent_step_id
  end
end
