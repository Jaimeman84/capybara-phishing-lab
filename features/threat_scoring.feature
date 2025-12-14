Feature: Threat Scoring and Risk Assessment
  As a security system
  I want to calculate accurate threat scores
  So that analysts can prioritize high-risk emails

  Scenario: Calculate threat score for email with multiple indicators
    Given there is an email with URL, sender, and content indicators
    When the email is analyzed
    Then the threat score should reflect all indicators
    And the risk level should be appropriate for the score

  Scenario: Low risk email receives low threat score
    Given there is an email with no phishing indicators
    When the email is analyzed
    Then the threat score should be between 0 and 25
    And the risk level should be "low"

  Scenario: Medium risk email receives medium threat score
    Given there is an email with minor phishing indicators
    When the email is analyzed
    Then the threat score should be between 26 and 50
    And the risk level should be "medium"

  Scenario: High risk email receives high threat score
    Given there is an email with several phishing indicators
    When the email is analyzed
    Then the threat score should be between 51 and 75
    And the risk level should be "high"

  Scenario: Critical risk email receives critical threat score
    Given there is an email with severe phishing indicators
    When the email is analyzed
    Then the threat score should be between 76 and 100
    And the risk level should be "critical"

  Scenario: Threat score caps at 100
    Given there is an email with excessive phishing indicators
    When the email is analyzed
    Then the threat score should not exceed 100
    And the risk level should be "critical"
