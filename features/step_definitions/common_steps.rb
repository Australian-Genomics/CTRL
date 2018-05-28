Then(/^I should see the (.*) link$/) do |link_text|
  expect(page).to have_link(link_text)
end

When(/^I fill the (\w+) field with value '(.*)'$/) do |field_name, value|
  fill_in field_name, with: value
end
