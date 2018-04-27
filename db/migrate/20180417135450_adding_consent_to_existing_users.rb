class AddingConsentToExistingUsers < ActiveRecord::Migration[5.2]
  def change
    User.all.each(&:save)
  end
end
