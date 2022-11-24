def create_visitor
  @study_id_regexp_str = "\\AA[0-4]{1}[0-9]{1}[2-4]{1}[0-9]{4}\\z"
  @study_id_regexp = Regexp.new(@study_id_regexp_str)

  @study_id_random_example_1 = @study_id_regexp.random_example
  @study_id_random_example_2 = @study_id_regexp.random_example

  @visitor ||= { first_name: 'Sushant',
                 family_name: 'Ahuja',
                 flagship: 'Acute Care Genomic Testing',
                 email: 'some@ahuja.com',
                 password: 'please2',
                 password_confirmation: 'please2',
                 dob: Date.today.at_beginning_of_month.last_month,
                 study_id: @study_id_random_example_1 }
end

def create_study_id
  unless StudyCode.find_by(title: @study_id_regexp_str)
    StudyCode.create!(title: @study_id_regexp_str)
  end
end

def delete_user
  create_visitor
  user = User.where(email: @visitor[:email]).first
  user.destroy unless user.nil?
end

def create_user
  create_visitor
  delete_user
  User.create!(@visitor)
end

def sign_in
  visit 'users/sign_in'
  fill_in 'user[email]', with: @visitor[:email]
  fill_in 'user[password]', with: @visitor[:password]
  click_button 'Log in'
end

def sign_up
  fill_in 'user[first_name]', with: @visitor[:first_name]
  fill_in 'user[family_name]', with: @visitor[:family_name]
  fill_in 'user[email]', with: @visitor[:email]

  # Using the datepicker, select the first day of last month
  find('input[name="user[dob]"]').click
  find('table > thead > tr > th.prev').click
  find('table > tbody > tr > td.day', text: /\A1\z/, match: :first).click
  find('input[name="user[dob]"]').send_keys(:escape)

  fill_in 'user[study_id]', with: @visitor[:study_id]
  fill_in 'user[password]', with: @visitor[:password]
  fill_in 'user[password_confirmation]', with: @visitor[:password_confirmation]
  find('#new_user > div.col.mb-30 > label > span').click
  click_button 'Register Now'
end

def edit_user_details
  fill_in 'user_first_name', with: 'kaku'
  fill_in 'user_middle_name', with: 'something'
  fill_in 'user_family_name', with: 'last'

  # Using the datepicker, select the first day of the month before the
  # previously selected one (i.e. two months ago)
  find('input[name="user[dob]"]').click
  find('table > thead > tr > th.prev').click
  find('table > tbody > tr > td.day', text: /\A1\z/, match: :first).click
  find('input[name="user[dob]"]').send_keys(:escape)

  fill_in 'user_email', with: 'sushant@sushant.com'
  fill_in 'user_address', with: '413'
  fill_in 'user_suburb', with: 'Zetland'
  select 'VIC', from: 'user_state'
  fill_in 'user_post_code', with: '3000'
  select 'Phone', from: 'user_preferred_contact_method'
  select 'chILDRANZ', from: 'user_flagship'
  fill_in 'user_study_id', with: @study_id_random_example_2
  find('#user_is_parent + span').click
  fill_in 'user_child_first_name', with: 'Luca'
  fill_in 'user_child_family_name', with: 'DSouza'

  # Using the datepicker, select the first day of last month
  find('input[name="user[child_dob]"]').click
  find('table > thead > tr > th.prev').click
  find('table > tbody > tr > td.day', text: /\A1\z/, match: :first).click
  find('input[name="user[child_dob]"]').send_keys(:escape)
end

Given('I am not logged in') do
  visit 'dashboard'
  if has_button?('Log Out')
    click_button 'Log Out'
  end
end

Given('A study code exists') do
  create_study_id
end

Given('I do not exist as a user') do
  delete_user
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

When(/^I fill in the user details (without|invalid) filling the Study ID$/) do |arg|
  create_visitor
  study_id = arg.eql?('invalid') ? 'B1523456' : ''
  @visitor = @visitor.merge(study_id: study_id)
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
  fill_in 'user[dob]', with: ''
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
  expect(page).to have_content 'Log in'
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

Then('I should see an error {string} on the page') do |message|
  expect(page).to have_content(message)
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
  expect(page).to have_content(Date.today.at_beginning_of_month.last_month.last_month)
  expect(page).to have_content('sushant@sushant.com')
  expect(page).to have_content('413')
  expect(page).to have_content('Zetland')
  expect(page).to have_content('VIC')
  expect(page).to have_content('3000')
  expect(page).to have_content('Phone')
  expect(page).to have_content('chILDRANZ')
  expect(page).to have_content(@study_id_random_example_2)
  expect(page).to have_content('Luca')
end

Then('I should not see the new name on the user edit page') do
  expect(page).to_not have_field('user[first_name]', with: 'kaku')
  expect(page).to_not have_field('user[middle_name]', with: 'something')
  expect(page).to_not have_field('user[family_name]', with: 'last')
  expect(page).to_not have_field('user[email]', with: 'sushant@sushant.com')
  expect(page).to_not have_field('user[address]', with: '413')
  expect(page).to_not have_field('user[suburb]', with: 'Zetland')
  expect(page).to_not have_field('user[state]', with: 'VIC')
  expect(page).to_not have_field('user[post_code]', with: '3000')
  expect(page).to_not have_field('user[preferred_contact_method]', with: 'Phone')
  expect(page).to_not have_field('user[flagship]', with: 'chILDRANZ')
  expect(page).to have_content('Next of Kin')
end

Then('I should see the user edit page') do
  expect(page).to have_content('Edit personal details')
end

Then('I should see error on edit page') do
  expect(page).to have_content("Can't be blank", count: 3)
  expect(page).to have_content('Invalid format')
end

Then('I should see \'Invalid format\' error on edit page') do
  expect(page).to have_content('Invalid format', count: 1)
end
