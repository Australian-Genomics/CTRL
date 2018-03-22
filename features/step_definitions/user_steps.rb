def create_visitor
  @visitor ||= { first_name: 'Sushant',
                 family_name: 'Ahuja',
                 flagship: 'Acute Care Genomic Testing',
                 email: 'some@ahuja.com',
                 password: 'please2',
                 password_confirmation: 'please2' }
end

def create_user
  create_visitor
  delete_user
  @user = User.create(@visitor)
end

def sign_in
  visit 'users/sign_in'
  fill_in 'user[email]', with: @visitor[:email]
  fill_in 'user[password]', with: @visitor[:password]
  click_button 'Log In'
end

def sign_up
  fill_in 'user_first_name', with: @visitor[:first_name]
  fill_in 'user_family_name', with: @visitor[:family_name]
  fill_in 'user_email', with: @visitor[:email]
  select 'Acute Care Genomic Testing', from: 'user_flagship'
  fill_in 'user_password', with: @visitor[:password]
  fill_in 'user_password_confirmation', with: @visitor[:password_confirmation]
  click_button 'Register Now'
end

def delete_user
  @user ||= User.where(email: @visitor[:email]).first
  @user.destroy unless @user.nil?
end

Given('I am not logged in') do
  visit 'users/sign_in'
  expect(page).to_not have_content('Logout')
end

Given('I exist as a user') do
  create_user
end

When('I sign in with valid credentials') do
  create_visitor
  sign_in
end

When('I sign in with a wrong email') do
  @visitor = @visitor.merge(email: 'wrong@example.com')
  sign_in
end

When('I sign in with a wrong password') do
  @visitor = @visitor.merge(password: 'wrongpass')
  sign_in
end

When('I click on Register') do
  visit 'users/sign_up'
end

When('I fill in the user details') do
  create_visitor
  sign_up
end

When('I did not fill in the user details') do
  create_visitor
  @visitor = @visitor.merge(first_name: '')
  @visitor = @visitor.merge(family_name: '')
  @visitor = @visitor.merge(email: '')
  @visitor = @visitor.merge(password: '')
  @visitor = @visitor.merge(password_confirmation: '')
  sign_up
end

When('I fill in the user details without filling the first name') do
  create_visitor
  @visitor = @visitor.merge(first_name: '')
  sign_up
end

When('I fill in the user details without filling the family name') do
  create_visitor
  @visitor = @visitor.merge(family_name: '')
  sign_up
end

When('I fill in the user details with invalid email') do
  create_visitor
  @visitor = @visitor.merge(email: 'wrongexample.com')
  sign_up
end

When('I fill in the user details with short password') do
  create_visitor
  @visitor = @visitor.merge(password: 'wrong')
  sign_up
end

When('I fill in the user details with wrong confirm password') do
  create_visitor
  @visitor = @visitor.merge(password_confirmation: 'wrongpass')
  sign_up
end

Then('I see an invalid login message') do
  expect(page).to have_content('If you don’t have an account, please Register')
end

Then('I should be signed out') do
  expect(page).to have_content 'Log In'
  expect(page).to_not have_content 'Logout'
end

Then('I should see the welcome message') do
  visit '/step_one'
  expect(page).to have_content 'Introduction to this platform'
end

Then('I should be signed in') do
  visit '/dashboard'
  expect(page).to have_content 'Logout'
  expect(page).to have_content 'Sushant'
end

Then('I should not see the welcome message') do
  expect(page).to have_content "can't be blank"
end

Then('I should see an error {string} on the page') do |_string|
  expect(page).to have_content 'is invalid'
end

Then('I should see an error under the password field') do
  expect(page).to have_content 'is too short (minimum is 6 characters)'
end

Then('I should see an error under the confirm password field') do
  expect(page).to have_content "doesn't match Password"
end

Then('I should see the error cannot be blank') do
  expect(page).to have_content "can't be blank"
end
