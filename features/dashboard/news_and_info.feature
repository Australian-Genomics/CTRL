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
    Then I click on the "News and Information" link
    And I should see an introduction about the platform

  Scenario: User can go to the dashboard page
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page
    Then I click on the "News and Information" link
    And I should see an introduction about the platform
    When I click on My Activities
    Then I should see the dashboard page

  Scenario: User can go to the my personal details page
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page
    Then I click on the "News and Information" link
    And I should see an introduction about the platform
    When I click on My Personal Details
    Then I should see the personal details page

  Scenario: User can logout
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page
    Then I click on the "News and Information" link
    And I should see an introduction about the platform
    When I click on Log Out
    Then I should be signed out