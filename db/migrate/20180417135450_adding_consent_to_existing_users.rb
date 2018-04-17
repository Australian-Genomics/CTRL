class AddingConsentToExistingUsers < ActiveRecord::Migration[5.2]
  def change
    User.all.each do |user|
      user.save
    end
  end
end
