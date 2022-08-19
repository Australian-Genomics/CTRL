Feature: Welcome Page
  In order to see the welcome page
  A user
  should be able to sign in or sign up

  Scenario: User signs up successfully
    Given I do not exist as a user
    And A study code exists
    When I click on Register
    And I fill in the user details
    Then I should see the welcome message

  Scenario: User signs in successfully
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in

  Scenario: User signs out successfully
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    When I click on Log Out
    Then I should be signed out

  Scenario: User sees the dashboard page when logged in
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    When I visit homepage
    Then I should see the dashboard page
