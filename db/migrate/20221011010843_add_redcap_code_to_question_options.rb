class AddRedcapCodeToQuestionOptions < ActiveRecord::Migration[5.2]
  def change
    add_column :question_options, :redcap_code, :string
  end
end
