def create_visitor
  @visitor ||= { first_name: 'Sushant',
                 family_name: 'Ahuja',
                 flagship: 'Acute Care Genomic Testing',
                 email: 'some@ahuja.com',
                 password: 'please2',
                 password_confirmation: 'please2',
                 study_id: 'Curve18' }
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
  fill_in 'user_study_id', with: @visitor[:study_id]
  fill_in 'user_password', with: @visitor[:password]
  fill_in 'user_password_confirmation', with: @visitor[:password_confirmation]
  click_button 'Register Now'
end

def delete_user
  @user ||= User.where(email: @visitor[:email]).first
  @user.destroy unless @user.nil?
end

def edit_user_details
  fill_in 'user_first_name', with: 'kaku'
  fill_in 'user_middle_name', with: 'something'
  fill_in 'user_family_name', with: 'last'
  fill_in 'user_dob', with: '30-05-1995'
  fill_in 'user_email', with: 'sushant@sushant.com'
  fill_in 'user_address', with: '413'
  fill_in 'user_suburb', with: 'Zetland'
  select 'VIC', from: 'user_state'
  fill_in 'user_post_code', with: '3000'
  select 'Phone', from: 'user_preferred_contact_method'
  select 'chILDRANZ', from: 'user_flagship'
  fill_in 'user_study_id', with: 'Research'
  find('#user_is_parent + span').click
  fill_in 'user_child_first_name', with: 'Luca'
  fill_in 'user_child_family_name', with: 'DSouza'
  fill_in 'user_child_dob', with: '30-05-1995'
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

When('I fill in the user details without filling the Study ID') do
  create_visitor
  @visitor = @visitor.merge(study_id: '')
  sign_up
end

When('I click on Update') do
  click_link('Update')
end

When('I edit the user details') do
  edit_user_details
end

When('I did not fill the mandatory fields') do
  fill_in 'user_first_name', with: 'kaku'
  fill_in 'user_middle_name', with: 'something'
  fill_in 'user_family_name', with: 'last'
  fill_in 'user_dob', with: ''
  fill_in 'user_email', with: 'sushant@sushant.com'
  fill_in 'user_address', with: '413'
  fill_in 'user_suburb', with: ''
  fill_in 'user_post_code', with: '3000'
  select 'chILDRANZ', from: 'user_flagship'
  fill_in 'user_study_id', with: 'Research'
end

When('I submit the user details') do
  click_button 'Update'
end

When('I click on Cancel') do
  click_link 'Cancel'
end

Then('I see an invalid login message') do
  expect(page).to have_content('Invalid Email or password.')
end

Then('I should not be signed in') do
  expect(page).to have_content 'Log In'
  expect(page).to_not have_content 'Logout'
end

Then('I should see the welcome message') do
  expect(page).to have_content 'Step 1 of 5'
end

Then('I should be signed in') do
  expect(page).to have_content 'Log Out'
end

Then('I should not see the welcome message') do
  expect(page).to have_content "Can't be blank"
end

Then('I should see an error {string} on the page') do |_string|
  expect(page).to have_content 'Is invalid'
end

Then('I should see an error under the password field') do
  expect(page).to have_content 'Is too short (minimum is 6 characters)'
end

Then('I should see an error under the confirm password field') do
  expect(page).to have_content "Doesn't match password"
end

Then('I should see the error cannot be blank') do
  expect(page).to have_content "Can't be blank"
end

Then('I should see Personal Details page') do
  expect(page).to have_content('My Personal Details')
end

Then('I should see the new name on the user edit page') do
  expect(page).to have_content('kaku')
  expect(page).to have_content('something')
  expect(page).to have_content('last')
  expect(page).to have_content('30-05-1995')
  expect(page).to have_content('sushant@sushant.com')
  expect(page).to have_content('413')
  expect(page).to have_content('Zetland')
  expect(page).to have_content('VIC')
  expect(page).to have_content('3000')
  expect(page).to have_content('Phone')
  expect(page).to have_content('chILDRANZ')
  expect(page).to have_content('Research')
  expect(page).to have_content('Yes')
  expect(page).to have_content('Registering on behalf of')
end

Then('I should not see the new name on the user edit page') do
  expect(page).to_not have_content('kaku')
  expect(page).to_not have_content('something')
  expect(page).to_not have_content('last')
  expect(page).to_not have_content('sushant@sushant.com')
  expect(page).to_not have_content('413')
  expect(page).to_not have_content('Zetland')
  expect(page).to_not have_content('VIC')
  expect(page).to_not have_content('3000')
  expect(page).to_not have_content('Phone')
  expect(page).to_not have_content('chILDRANZ')
  expect(page).to_not have_content('Research')
  expect(page).to_not have_content('Yes')
  expect(page).to have_content('Next of Kin:')
end

Then('I should see the user edit page') do
  expect(page).to have_content('Edit personal details')
end

Then('I should see error on edit page') do
  expect(page).to have_content("Can't be blank", count: 5)
end
