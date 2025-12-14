Feature: Admin Dashboard
  As a security administrator
  I want to view analytics and metrics
  So that I can monitor the overall security posture

  Background:
    Given the database is seeded with test data

  Scenario: View dashboard overview
    When I visit the admin dashboard
    Then I should see the dashboard title
    And I should see total emails count
    And I should see reported emails count
    And I should see threat distribution metrics

  Scenario: View threat distribution by risk level
    Given there are emails with different risk levels
    When I visit the admin dashboard
    Then I should see low risk count
    And I should see medium risk count
    And I should see high risk count
    And I should see critical risk count

  Scenario: View phishing vs legitimate email ratio
    Given there are both phishing and legitimate emails
    When I visit the admin dashboard
    Then I should see the phishing email count
    And I should see the legitimate email count
    And the total should match all emails

  Scenario: Dashboard displays recent activity
    Given there are recently reported emails
    When I visit the admin dashboard
    Then I should see statistics about reported emails
    And the metrics should be accurate
