Then(/^I should see the (.*) link$/) do |link_text|
  expect(page).to have_link(link_text)
end

Then(/^I should see date from the future error on edit page$/) do
  expect(page).to have_content("Can't be a date in the future")
end

When(/^I fill the (\w+) field with value '(.*)'$/) do |field_name, value|
  fill_in field_name, with: value
end

When(/^I fill the user (.*?) date of birth field with future date$/) do |child|
  if child.eql?('child')
    find('#user_is_parent + span').click
    fill_in 'user_child_first_name', with: 'Luca'
    fill_in 'user_child_family_name', with: 'DSouza'
    fill_in 'user_child_dob', with: Date.tomorrow.to_s
  else
    fill_in 'user[dob]', with: Date.tomorrow.to_s
  end
end

When(/^I (?:click|press) on the( first)? "(.*?)" (?:link|button)$/) do |first, link_text|
  if first
    page.click_on(link_text.to_s, match: :prefer_exact)
  else
    page.click_on(link_text.to_s)
  end
end

Then(/^I should( not)? see "([^"]*)"$/) do |negate, text|
  # negate ? page.should_not(have_content(text)) : page.should(have_content(text))
  if negate
    expect(page).to_not have_content(text)
  else
    expect(page).to have_content(text)
  end
end

When(/^I fill in "(.*?)" with "(.*?)"$/) do |field, value|
  fill_in(field, with: value.to_s)
end

When('I click all the checkboxes') do
  all('.controls__checkbox').each do |element|
    element.click
  end
end

When(/I click the link '([^']+)'/) do |link_text|
  click_link(link_text)
end

