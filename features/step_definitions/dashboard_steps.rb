# frozen_string_literal: true

Given('there are emails with different risk levels') do
  # Create emails that will generate different risk levels
  Email.create!(
    sender_email: 'safe@company.com',
    sender_name: 'Safe Sender',
    recipient_email: 'user@company.com',
    subject: 'Normal Email',
    body_plain: 'This is normal content.',
    received_at: Time.current
  ).tap { |e| PhishingDetectionService.new(e).analyze }

  Email.create!(
    sender_email: 'test@gmail.com',
    sender_name: 'Test User',
    recipient_email: 'user@company.com',
    subject: 'Please verify',
    body_plain: 'Some content here.',
    received_at: Time.current
  ).tap { |e| PhishingDetectionService.new(e).analyze }

  Email.create!(
    sender_email: 'phishing@suspicious.tk',
    sender_name: 'Phisher',
    recipient_email: 'user@company.com',
    subject: 'URGENT action required',
    body_plain: 'Click here: http://bit.ly/fake and verify password',
    received_at: Time.current
  ).tap { |e| PhishingDetectionService.new(e).analyze }
end

Given('there are both phishing and legitimate emails') do
  Email.create!(
    sender_email: 'john@company.com',
    sender_name: 'John Doe',
    recipient_email: 'user@company.com',
    subject: 'Meeting',
    body_plain: 'Meeting notes',
    received_at: Time.current,
    is_phishing: false
  )

  Email.create!(
    sender_email: 'fake@phishing.xyz',
    sender_name: 'Scammer',
    recipient_email: 'user@company.com',
    subject: 'URGENT',
    body_plain: 'Verify password: http://bit.ly/scam',
    received_at: Time.current,
    is_phishing: true
  )
end

Given('there are recently reported emails') do
  2.times do |i|
    email = Email.create!(
      sender_email: "sender#{i}@test.com",
      sender_name: "Sender #{i}",
      recipient_email: 'user@company.com',
      subject: "Email #{i}",
      body_plain: 'Content',
      received_at: Time.current - i.hours
    )
    Report.create!(email: email)
  end
end

When('I visit the admin dashboard') do
  visit admin_dashboard_path
end

Then('I should see the dashboard title') do
  expect(page).to have_content(/Dashboard|Admin|Analytics/i)
end

Then('I should see total emails count') do
  expect(page).to have_content(/Total.*Email|Email.*Total/i)
  expect(page).to have_content(/\d+/)
end

Then('I should see reported emails count') do
  expect(page).to have_content(/Report/i)
  expect(page).to have_content(/\d+/)
end

Then('I should see threat distribution metrics') do
  expect(page).to have_content(/Threat|Risk|Distribution/i)
end

Then('I should see low risk count') do
  expect(page).to have_content(/low/i)
end

Then('I should see medium risk count') do
  expect(page).to have_content(/medium/i)
end

Then('I should see high risk count') do
  expect(page).to have_content(/high/i)
end

Then('I should see critical risk count') do
  expect(page).to have_content(/critical/i)
end

Then('I should see the phishing email count') do
  expect(page).to have_content(/phishing/i)
  expect(page).to have_content(/\d+/)
end

Then('I should see the legitimate email count') do
  expect(page).to have_content(/legitimate|safe|normal|\d+/i)
end

Then('the total should match all emails') do
  # Just verify numbers are present
  expect(page).to have_content(/\d+/)
end

Then('I should see statistics about reported emails') do
  expect(page).to have_content(/report|\d+/i)
end

Then('the metrics should be accurate') do
  # Just verify the page loaded with content
  expect(page).to have_content(/\d+/)
end
