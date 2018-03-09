Feature: Welcome Page
  In order to see the welcome page
  A user
  should be able to sign in or sign up

  Scenario: User is not signed up
    When I sign in with valid credentials
    Then I see an invalid login message
    And I should be signed out

  Scenario: User signs up successfully
    When I click on Sign up
    And I fill in the user details
    Then I should see the welcome message