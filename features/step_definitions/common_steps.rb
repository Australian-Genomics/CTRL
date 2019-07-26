Then(/^I should see the (.*) link$/) do |link_text|
  expect(page).to have_link(link_text)
end

Then('I should see date from the future error on edit page') do
  expect(page).to have_content("Can't enter the date from the future")
end

When(/^I fill the (\w+) field with value '(.*)'$/) do |field_name, value|
  fill_in field_name, with: value
end

When('I fill the user date of birth field with future date') do
  fill_in 'user_dob', with: Date.tomorrow.to_s
end
