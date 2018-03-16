def create_visitor
  @visitor ||= { email: 'example3@example.com',
                 password: 'please2', password_confirmation: 'please2' }
end

def create_user
  @visitor ||= { first_name: 'Sushant',
                 middle_name: 'Ahuja',
                 email: 'example@example.com',
                 password: 'please2',
                 password_confirmation: 'please2' }
end

def sign_in
  visit 'users/sign_in'
  fill_in 'user_email', with: @visitor[:email]
  fill_in 'user_password', with: @visitor[:password]
  click_button 'Log in'
end

def sign_up
  fill_in 'user_first_name', with: @visitor[:first_name]
  fill_in 'user_middle_name', with: @visitor[:middle_name]
  fill_in 'user_email', with: @visitor[:email]
  fill_in 'user_password', with: @visitor[:password]
  fill_in 'user_password_confirmation', with: @visitor[:password_confirmation]
  click_button 'Create User'
end

When('I sign in with valid credentials') do
  create_visitor
  sign_in
end

When('I click on Register') do
  visit 'users/sign_up'
end

When('I fill in the user details') do
  create_user
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
