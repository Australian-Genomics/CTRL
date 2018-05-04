Feature: Error Page
  In Order to see the Error Page
  A User
  Should visit the page that does not exist

  Scenario: User sees the 404 page when logged in
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page
    When I visit the page that does not exist
    Then I should see the 404 page

  Scenario: User can go to the dashboard page from 404 error page
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page
    When I visit the page that does not exist
    Then I should see the 404 page
    When I click on Back to homepage
    Then I should see the dashboard page

  Scenario: User can go to the previous page from 404 error page
    When I click on Register
    And I fill in the user details
    Then I should see the welcome message
    When I visit the page that does not exist
    Then I should see the 404 page
    When I click on Return to previous page
    Then I should see the step one of consent

  Scenario: User sees the 404 page when not logged in
    When I sign in with valid credentials
    Then I see an invalid login message
    And I should not be signed in
    When I visit the page that does not exist
    Then I should see the 404 page

  Scenario: User sees the welcome page after clicking on Back to homepage from 404 error page
    When I sign in with valid credentials
    Then I see an invalid login message
    And I should not be signed in
    When I visit the page that does not exist
    Then I should see the 404 page
    When I click on Back to homepage
    Then I should see the welcome page

  Scenario: User sees the 500 page when logged in
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page
    When I get an internal server error
    Then I should see the '500' page

  Scenario: User can go to the dashboard page from 500 error page
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page
    When I get an internal server error
    Then I should see the '500' page
    When I click on Back to homepage
    Then I should see the dashboard page

  Scenario: User can go to the previous page from 500 error page
    When I click on Register
    And I fill in the user details
    Then I should see the welcome message
    When I get an internal server error
    Then I should see the '500' page
    When I click on Return to previous page
    Then I should see the step one of consent

