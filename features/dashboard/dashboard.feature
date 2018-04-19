Feature: Dashboard Page
  In Order to see the Dashboard Page
  A user
  should be able to toggle between navbar links

  Scenario: User sees the about us page
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page

  Scenario: User sees the dashboard page
    When I click on Register
    And I fill in the user details
    Then I should see the welcome message
    When I click on the agha logo
    Then I should see the dashboard page
    And I should see the progress of my current consent step
    And I should see the step one that needs review
    When I click on Review
    Then I should see the step one of consent
    When I click on Save and Exit
    Then I should see the dashboard page as step one reviewed



