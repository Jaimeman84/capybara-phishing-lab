# frozen_string_literal: true

Given('there is an email with URL, sender, and content indicators') do
  @email = Email.create!(
    sender_name: 'PayPal Security',
    sender_email: 'security@paypa1.tk',
    recipient_email: 'user@company.com',
    subject: 'URGENT: Verify account',
    body_plain: 'Click here to verify password: http://bit.ly/fake',
    received_at: Time.current
  )
end

Given('there is an email with no phishing indicators') do
  @email = Email.create!(
    sender_name: 'John Smith',
    sender_email: 'john.smith@company.com',
    recipient_email: 'user@company.com',
    subject: 'Weekly Report',
    body_plain: 'Here is the weekly report for your review.',
    received_at: Time.current
  )
end

Given('there is an email with minor phishing indicators') do
  @email = Email.create!(
    sender_name: 'Support Team',
    sender_email: 'support@gmail.com',
    recipient_email: 'user@company.com',
    subject: 'Account Update',
    body_plain: 'Please review your account.',
    received_at: Time.current
  )
end

Given('there is an email with several phishing indicators') do
  @email = Email.create!(
    sender_name: 'Account Services',
    sender_email: 'noreply@account-update.info',
    recipient_email: 'user@company.com',
    subject: 'Please verify your account',
    body_plain: 'We noticed unusual activity. Please click here to review: http://account-verify.tk',
    received_at: Time.current
  )
end

Given('there is an email with severe phishing indicators') do
  @email = Email.create!(
    sender_name: 'Microsoft Security',
    sender_email: 'security@192.168.1.1',
    recipient_email: 'user@company.com',
    subject: 'URGENT: Password reset required immediately',
    body_plain: 'Download attachment.exe and verify your login credentials urgently: http://malicious.tk/verify',
    received_at: Time.current
  )
end

Given('there is an email with excessive phishing indicators') do
  @email = Email.create!(
    sender_name: 'PayPal Security Team Urgent',
    sender_email: 'noreply@paypa1-verify123.tk',
    recipient_email: 'user@company.com',
    subject: 'URGENT IMMEDIATE ACTION REQUIRED - Account Suspended',
    body_plain: 'Dear customer, your account has been suspended. Click here immediately: http://192.168.1.1/paypal.exe and verify your password, username, login credentials urgently or account will expire: http://bit.ly/verify',
    received_at: Time.current
  )
end

When('the email is analyzed') do
  @result = PhishingDetectionService.new(@email).analyze
  @email.reload
end

Then('the threat score should reflect all indicators') do
  expect(@email.threat_score).to be_present
  expect(@email.threat_score.score).to be > 0
end

Then('the risk level should be appropriate for the score') do
  score = @email.threat_score.score
  risk_level = @email.threat_score.risk_level

  case score
  when 0..25
    expect(risk_level).to eq('low')
  when 26..50
    expect(risk_level).to eq('medium')
  when 51..75
    expect(risk_level).to eq('high')
  when 76..100
    expect(risk_level).to eq('critical')
  end
end

Then('the threat score should be between {int} and {int}') do |min, max|
  expect(@email.threat_score.score).to be_between(min, max)
end

Then('the risk level should be {string}') do |expected_level|
  expect(@email.threat_score.risk_level).to eq(expected_level)
end

Then('the threat score should not exceed {int}') do |max_score|
  expect(@email.threat_score.score).to be <= max_score
end
