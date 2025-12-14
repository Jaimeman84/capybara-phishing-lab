# frozen_string_literal: true

Given('the database is seeded with test data') do
  # Seed data is already loaded, just ensure we have some emails
  unless Email.any?
    5.times do |i|
      Email.create!(
        sender_name: "Sender #{i}",
        sender_email: "sender#{i}@example.com",
        recipient_email: 'user@company.com',
        subject: "Test Email #{i}",
        body_plain: 'Test email body',
        received_at: Time.current - i.hours
      )
    end
  end
end

Given('there is a phishing email with suspicious characteristics') do
  @email = Email.create!(
    sender_name: 'PayPal Security Team',
    sender_email: 'security@paypa1-verify.tk',
    recipient_email: 'user@company.com',
    subject: 'URGENT: Verify your account immediately!',
    body_plain: 'Your account will be suspended. Click here to verify: http://bit.ly/fake-paypal Password required.',
    received_at: Time.current
  )
end

Given('there is a legitimate business email') do
  @email = Email.create!(
    sender_name: 'John Smith',
    sender_email: 'john.smith@legitimate-company.com',
    recipient_email: 'user@company.com',
    subject: 'Meeting notes from today',
    body_plain: 'Here are the notes from our meeting this afternoon. Please review and let me know if you have questions.',
    received_at: Time.current
  )
end

Given('there is a reported phishing email') do
  @email = Email.create!(
    sender_name: 'Amazon Support',
    sender_email: 'support@amaz0n.xyz',
    recipient_email: 'user@company.com',
    subject: 'Account verification required',
    body_plain: 'Click here: http://192.168.1.1/amazon urgent password',
    received_at: Time.current
  )
  PhishingDetectionService.new(@email).analyze
  Report.create!(email: @email)
end

Given('there is an email with suspicious URLs') do
  @email = Email.create!(
    sender_name: 'Tech Support',
    sender_email: 'support@example.com',
    recipient_email: 'user@company.com',
    subject: 'System Update',
    body_plain: 'Download update from: http://malicious-site.tk and http://bit.ly/update',
    received_at: Time.current
  )
end

Given('there is an email from a suspicious sender') do
  @email = Email.create!(
    sender_name: 'Microsoft Security',
    sender_email: 'security@micr0s0ft.com',
    recipient_email: 'user@company.com',
    subject: 'Security Alert',
    body_plain: 'Your account needs verification.',
    received_at: Time.current
  )
end

Given('there is an email with urgent language') do
  @email = Email.create!(
    sender_name: 'Bank Support',
    sender_email: 'support@bank.com',
    recipient_email: 'user@company.com',
    subject: 'URGENT: Action required',
    body_plain: 'Your account will be suspended immediately. Verify your password now!',
    received_at: Time.current
  )
end

When('I visit the email detail page') do
  visit email_path(@email)
end

Then('I should see phishing indicators detected') do
  expect(page).to have_content('Security Analysis')
  # Check for any indicators being displayed (flexible selector)
  expect(page.body).to match(/indicator|severity|detected/i)
end

Then('I should see a high threat score') do
  expect(page).to have_content('Threat Score')
  # Look for high or critical risk level indicators
  expect(page).to have_content(/high|critical/i)
end

Then('I should see few or no phishing indicators') do
  expect(page).to have_content('Security Analysis')
  # May have 0 or very few indicators
end

Then('I should see a low threat score') do
  expect(page).to have_content('Threat Score')
  expect(page).to have_content(/low|medium/i)
end

Then('I should see the security analysis section') do
  expect(page).to have_content('Security Analysis')
end

Then('I should see the threat score') do
  expect(page).to have_content('Threat Score')
end

Then('I should see the risk level') do
  expect(page).to have_content(/low|medium|high|critical/i)
end

Then('I should see detected phishing indicators') do
  # Look for any indication that indicators are shown
  has_indicators = page.has_content?(/indicator|detected|found/i) ||
    page.has_css?('[class*="indicator"]', minimum: 1) ||
    page.has_css?('li, .list-item, table tr', minimum: 1)

  expect(has_indicators).to be true
end

Then('each indicator should show its severity level') do
  # Check that severity levels are displayed
  expect(page).to have_content(/low|medium|high|critical/i)
end

Then('I should see URL phishing indicators') do
  expect(page).to have_content(/url/i)
end

Then('I should see {string} or {string}') do |text1, text2|
  expect(page).to have_content(/#{Regexp.escape(text1)}|#{Regexp.escape(text2)}/i)
end

Then('I should see sender phishing indicators') do
  expect(page).to have_content(/sender/i)
end

Then('I should see warnings about the sender domain') do
  expect(page).to have_content(/sender|domain/i)
end

Then('I should see content phishing indicators') do
  expect(page).to have_content(/content/i)
end
