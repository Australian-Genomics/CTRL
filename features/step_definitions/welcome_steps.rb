When('I click on Log Out') do
  click_link('Log Out')
end

Then('I should be signed out') do
  expect(page).to have_content('Register Now')
  expect(page).to have_content('Log in')
  expect(page).to_not have_content('Log Out')
end
