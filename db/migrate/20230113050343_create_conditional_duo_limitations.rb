class CreateConditionalDuoLimitations < ActiveRecord::Migration[5.2]
  def change
    create_table :conditional_duo_limitations do |t|
      t.text :json

      t.timestamps
    end

    create_join_table :conditional_duo_limitations, :consent_questions
  end
end
