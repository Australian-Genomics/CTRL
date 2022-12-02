Then('I should see the modal fallback') do
  expect(page).to have_content('Are you sure you don’t want the test?')
end
