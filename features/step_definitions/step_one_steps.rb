When('I click on Next') do
  click_button('Next')
end

When('I click on link Save and Exit') do
  click_button('Save and Exit')
end

Then('I should be on the step one of consent') do
  expect(page).to have_content('Introduction to this platform')
  expect(page).to have_button('Next')
  expect(page).to have_button('Save and Exit')
end

Then('I should be on the step two of the consent') do
  expect(page).to have_link('Back')
end

Then('I should come back to the step one page') do
  click_link('Back')
end

Then('I should the dashboard page') do
  expect(page).to have_content('Log Out')
end
