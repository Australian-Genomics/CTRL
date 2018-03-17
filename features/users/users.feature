Feature: Welcome Page
  In order to see the welcome page
  A user
  should be able to sign in or sign up

  Scenario: User is not signed up
    When I sign in with valid credentials
    Then I see an invalid login message
    And I should be signed out

  Scenario: User signs up successfully
    When I click on Register
    And I fill in the user details
    Then I should see the welcome message

  Scenario: User signs in successfully
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in

  Scenario: User enters wrong email
    Given I exist as a user
    And I am not logged in
    When I sign in with a wrong email
    Then I see an invalid login message
    And I should be signed out

  Scenario: User enters wrong password
    Given I exist as a user
    And I am not logged in
    When I sign in with a wrong password
    Then I see an invalid login message
    And I should be signed out
