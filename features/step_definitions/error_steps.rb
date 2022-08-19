When('I visit the page that does not exist') do
  visit '/404'
end

When('I get an internal server error') do
  visit '/500'
end

When('I click on Back to homepage') do
  click_link 'Back to homepage'
end

When('I click on Return to previous page') do
  click_link 'Return to previous page'
end

Then('I should see the {int} page') do |_int|
  expect(page).to have_content('Error code 404')
end

Then('I should see the welcome page') do
  expect(page).to have_link('Register Now')
  expect(page).to have_link('Log in')
end

Then('I should see the {string} page') do |_string|
  expect(page).to have_content('Error code 500')
end
