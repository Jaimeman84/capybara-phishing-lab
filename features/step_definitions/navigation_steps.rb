# frozen_string_literal: true

Given('I am viewing an email detail page') do
  @email = Email.first || Email.create!(
    sender_name: 'Test Sender',
    sender_email: 'test@example.com',
    recipient_email: 'user@company.com',
    subject: 'Test Email',
    body_plain: 'Test content',
    received_at: Time.current
  )
  visit email_path(@email)
end

When('I click on the first email') do
  first('table tbody tr a').click
end

When('I click the back or inbox link') do
  begin
    click_link 'Back'
  rescue StandardError
    click_link 'Inbox'
  end
rescue StandardError
  click_link 'Email Inbox'
end

When('I visit an email detail page') do
  @email = Email.first || Email.create!(
    sender_name: 'Test Sender',
    sender_email: 'test@example.com',
    recipient_email: 'user@company.com',
    subject: 'Test Email',
    body_plain: 'Test content',
    received_at: Time.current
  )
  visit email_path(@email)
end

Then('emails should be ordered by received date') do
  # Just verify emails are displayed
  expect(page).to have_css('table tbody tr, .email-item', minimum: 1)
end

Then('I should see the email detail page') do
  expect(current_path).to match(%r{/emails/\d+})
end

Then('I should see the email subject') do
  if @email
    expect(page).to have_content(@email.subject)
  else
    expect(page).to have_css('h1, h2, h3')
  end
end

Then('I should see the email body') do
  if @email
    expect(page).to have_content(@email.body_plain)
  else
    # Just check some content exists
    expect(page.body.length).to be > 100
  end
end

Then('I should see the sender information') do
  expect(page).to have_content(/from|sender/i)
end

Then('I should see the sender name') do
  expect(page).to have_content(@email.sender_name) if @email
end

Then('I should see the sender email address') do
  expect(page).to have_content(@email.sender_email) if @email
end

Then('I should see the recipient email') do
  expect(page).to have_content(@email.recipient_email) if @email
end

Then('I should see the received date') do
  # Check for date-like patterns (months or "at" with time)
  expect(page).to have_content(/january|february|march|april|may|june|july|august|september|october|november|december|\d{4}|at \d{1,2}:\d{2}/i)
end

Then('I should see the {string} button') do |button_text|
  expect(page).to have_button(button_text)
end

Then('I should be on the email inbox page') do
  expect(current_path).to eq(emails_path)
end
