class AddingDefaultValueToExistingUsers < ActiveRecord::Migration[5.2]
  def change
    User.all.map &:create_consent_step
  end

end
