When("I click on I don't want the test") do
  click_link("I don't want the test")
end

Then("I should be on the review answers page") do
  expect(page).to have_link("I don't want the test")
  expect(page).to have_link('Review Answers')
end