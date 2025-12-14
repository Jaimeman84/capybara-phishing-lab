Feature: Email Navigation and Filtering
  As a user
  I want to browse and filter emails
  So that I can efficiently review my inbox

  Background:
    Given there are 25 emails in the system

  Scenario: View email inbox with all emails
    When I visit the email inbox
    Then I should see all 25 emails
    And emails should be ordered by received date

  Scenario: Navigate from inbox to email detail
    When I visit the email inbox
    And I click on the first email
    Then I should see the email detail page
    And I should see the email subject
    And I should see the email body
    And I should see the sender information

  Scenario: View email metadata
    When I visit an email detail page
    Then I should see the sender name
    And I should see the sender email address
    And I should see the recipient email
    And I should see the received date
    And I should see the email subject

  Scenario: Report button is available for unreported emails
    Given there is an unreported email
    When I visit the email detail page
    Then I should see the "Report as Phishing" button

  Scenario: Navigate back to inbox from email detail
    Given I am viewing an email detail page
    When I click the back or inbox link
    Then I should be on the email inbox page
