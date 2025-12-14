Feature: Email Reporting
  As a user
  I want to report suspicious emails
  So that they can be analyzed for phishing threats

  Scenario: View email inbox
    Given there are 10 emails in the system
    When I visit the email inbox
    Then I should see all 10 emails

  Scenario: Report an email as phishing
    Given there is an unreported email
    When I report the email as phishing
    Then the email should be marked as reported
    And I should see the threat analysis
