Feature: Dashboard Page
  In Order to see the Dashboard Page
  A user
  should be able to toggle between navbar links

  Scenario: User sees the contact us page
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page
    Then I click on the "Contact Us" link
    And I should see the contact us details

  Scenario: User can go to the dashboard page from contact us page
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page
    Then I click on the "Contact Us" link
    And I should see the contact us details
    When I click on the "My Activities" link
    Then I should see the dashboard page

  Scenario: User can go to the my personal details page from contact us page
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page
    Then I click on the "Contact Us" link
    And I should see the contact us details
    When I click on the "My Personal Details" link
    Then I should see the personal details page

  Scenario: User can logout from contact us page
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page
    Then I click on the "Contact Us" link
    And I should see the contact us details
    When I click on the "Log Out" link
    Then I should be signed out

  Scenario: User attempts to send blank message
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page
    Then I click on the "Contact Us" link
    And I should see the contact us details
    When I click on the "Send" button
    Then I should see "Message content can't be blank."

  Scenario: User to send message successfully
    Given I exist as a user
    And I am not logged in
    When I sign in with valid credentials
    Then I should be signed in
    And I should see the dashboard page
    Then I click on the "Contact Us" link
    And I should see the contact us details
    And I fill in "contact_us_message" with "Hi"
    When I click on the "Send" button
    Then I should see "Thank you for contacting the Australian Genomics research program"
