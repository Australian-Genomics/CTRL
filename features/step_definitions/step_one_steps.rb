When('I click on Next') do
  click_link('Next')
end

When('I click on Save and Exit') do
  click_link('Save and Exit')
end

Then('I should see the step one of consent') do
  expect(page).to have_content('Introduction to this platform')
  expect(page).to have_link('Next')
  expect(page).to have_link('Save and Exit')
end

Then('I should see the step two of the consent') do
  expect(page).to have_link('Back')
end

Then('I should come back to the step one') do
  click_link('Back')
end

Then('I should the dashboard page') do
  expect(page).to have_content('logged in')
end
