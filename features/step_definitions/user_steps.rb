def create_visitor
  @visitor ||= { first_name: 'Sushant',
                 family_name: 'Ahuja',
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
  fill_in 'user_email', with: @visitor[:email]
  fill_in 'user_password', with: @visitor[:password]
  click_button 'Log in'
end

def sign_up
  fill_in 'user_first_name', with: @visitor[:first_name]
  fill_in 'user_family_name', with: @visitor[:family_name]
  fill_in 'user_email', with: @visitor[:email]
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
  expect(page).to_not have_content('Hello Cucumber')
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

Then('I see an invalid login message') do
  expect(page).to have_content('Invalid Email or password')
end

Then('I should be signed out') do
  expect(page).to have_content 'Log in'
  expect(page).to_not have_content 'Logout'
end

Then('I should see the welcome message') do
  expect(page).to have_content 'Hello Cucumber'
end

Then('I should be signed in') do
  page.should have_content 'Hello Cucumber'
end
