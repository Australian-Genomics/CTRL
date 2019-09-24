Then('I should see the contact us details') do
  expect(page).to have_content('Please enter your message')
end
