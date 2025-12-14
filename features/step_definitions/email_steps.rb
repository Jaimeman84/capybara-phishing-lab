# frozen_string_literal: true

Given('there are {int} emails in the system') do |count|
  count.times do |i|
    Email.create!(
      sender_name: "Sender #{i + 1}",
      sender_email: "sender#{i + 1}@example.com",
      recipient_email: 'user@company.com',
      subject: "Email Subject #{i + 1}",
      body_plain: "Email body content #{i + 1}",
      received_at: Time.current - i.hours
    )
  end
end

When('I visit the email inbox') do
  visit emails_path
end

Then('I should see all {int} emails') do |count|
  # Wait for the page to load
  expect(page).to have_content('Email Inbox')
  # Check for table rows (the inbox uses a table)
  expect(page).to have_selector('table tbody tr', count: count)
end

Given('there is an unreported email') do
  @email = Email.create!(
    sender_name: 'Phishing Sender',
    sender_email: 'phishing@suspicious.com',
    recipient_email: 'user@company.com',
    subject: 'URGENT: Verify your account',
    body_plain: 'Click here to verify: http://bit.ly/fake',
    received_at: Time.current
  )
end

When('I report the email as phishing') do
  visit email_path(@email)
  click_button 'Report as Phishing'
end

Then('the email should be marked as reported') do
  @email.reload
  expect(@email.reported?).to be true
end

Then('I should see the threat analysis') do
  expect(page).to have_content('Security Analysis')
  expect(page).to have_content('Threat Score')
end
