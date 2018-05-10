Then(/^I should see the (.*) link$/) do |link_text|
  expect(page).to have_link(link_text)
end
