Feature: Phishing Detection and Analysis
  As a security analyst
  I want to analyze emails for phishing indicators
  So that I can identify and respond to security threats

  Background:
    Given the database is seeded with test data

  Scenario: Detect phishing indicators in suspicious email
    Given there is a phishing email with suspicious characteristics
    When I visit the email detail page
    And I report the email as phishing
    Then I should see phishing indicators detected
    And I should see a high threat score
    And the email should be marked as reported

  Scenario: Analyze legitimate email
    Given there is a legitimate business email
    When I visit the email detail page
    And I report the email as phishing
    Then I should see few or no phishing indicators
    And I should see a low threat score

  Scenario: View detailed threat analysis
    Given there is a reported phishing email
    When I visit the email detail page
    Then I should see the security analysis section
    And I should see the threat score
    And I should see the risk level
    And I should see detected phishing indicators
    And each indicator should show its severity level

  Scenario: Detect URL-based phishing indicators
    Given there is an email with suspicious URLs
    When I report the email as phishing
    Then I should see URL phishing indicators
    And I should see "Suspicious top-level domain" or "URL shortener detected"

  Scenario: Detect sender-based phishing indicators
    Given there is an email from a suspicious sender
    When I report the email as phishing
    Then I should see sender phishing indicators
    And I should see warnings about the sender domain

  Scenario: Detect content-based phishing indicators
    Given there is an email with urgent language
    When I report the email as phishing
    Then I should see content phishing indicators
    And I should see "Urgency language detected" or "Credential request detected"
