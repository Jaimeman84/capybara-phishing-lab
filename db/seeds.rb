# frozen_string_literal: true

puts "Clearing existing data..."
ThreatScore.delete_all
PhishingIndicator.delete_all
Report.delete_all
Email.delete_all

puts "Creating demo emails..."

# Legitimate Emails
Email.create!([
  {
    sender_email: 'john.smith@company.com',
    sender_name: 'John Smith',
    recipient_email: 'user@example.com',
    subject: 'Q4 Project Update',
    body_plain: "Hi Team,\n\nJust wanted to share the latest updates on our Q4 projects. Everything is on track and we're meeting our milestones.\n\nBest regards,\nJohn",
    received_at: 2.days.ago,
    is_phishing: false
  },
  {
    sender_email: 'hr@company.com',
    sender_name: 'HR Department',
    recipient_email: 'user@example.com',
    subject: 'Benefits Enrollment Reminder',
    body_plain: "Hello,\n\nThis is a reminder that benefits enrollment closes next Friday. Please review your options in the HR portal.\n\nThank you,\nHR Team",
    received_at: 1.day.ago,
    is_phishing: false
  },
  {
    sender_email: 'newsletter@techcompany.com',
    sender_name: 'Tech Newsletter',
    recipient_email: 'user@example.com',
    subject: 'Weekly Tech Digest',
    body_plain: "Your weekly roundup of the latest tech news and trends.\n\nTop Stories:\n- AI advancements\n- Cloud computing updates\n- Security best practices",
    received_at: 3.hours.ago,
    is_phishing: false
  }
])

# Phishing Email 1: Credential Harvesting
Email.create!(
  sender_email: 'security@micros0ft.com',
  sender_name: 'Microsoft Security',
  recipient_email: 'user@example.com',
  subject: 'URGENT: Your account will be suspended',
  body_plain: "Dear customer,\n\nYour Microsoft account has been flagged for suspicious activity. You must verify your account immediately or it will be suspended within 24 hours.\n\nClick here to verify: http://bit.ly/verify-account\n\nMicrosoft Security Team",
  received_at: 5.hours.ago,
  is_phishing: true,
  phishing_type: 'credential_harvest'
)

# Phishing Email 2: Malware Delivery
Email.create!(
  sender_email: 'invoices@supplier-company.xyz',
  sender_name: 'Accounts Payable',
  recipient_email: 'user@example.com',
  subject: 'Invoice #45832 - Action Required',
  body_plain: "Hello,\n\nPlease find attached the invoice for last month's services. Download the attachment to view full details.\n\nClick to download: http://192.168.1.100/invoice.exe\n\nThank you",
  received_at: 1.day.ago,
  is_phishing: true,
  phishing_type: 'malware'
)

# Phishing Email 3: Social Engineering
Email.create!(
  sender_email: 'support@paypa1.com',
  sender_name: 'PayPal Support',
  recipient_email: 'user@example.com',
  subject: 'Your payment has been declined',
  body_plain: "Dear valued customer,\n\nWe were unable to process your recent payment. Please update your billing information immediately to avoid service interruption.\n\nVerify your account: http://tinyurl.com/paypal-verify\n\nPayPal Team",
  received_at: 3.days.ago,
  is_phishing: true,
  phishing_type: 'social_engineering'
)

# Phishing Email 4: CEO Fraud (BEC)
Email.create!(
  sender_email: 'ceo@gmail.com',
  sender_name: 'CEO Office',
  recipient_email: 'user@example.com',
  subject: 'Urgent wire transfer needed',
  body_plain: "Hi,\n\nI need you to process an urgent wire transfer to our new vendor. This is confidential and time-sensitive.\n\nPlease confirm you can handle this immediately.\n\nThanks",
  received_at: 6.hours.ago,
  is_phishing: true,
  phishing_type: 'bec'
)

# More Phishing Examples
Email.create!([
  {
    sender_email: 'no-reply@amaz0n.com',
    sender_name: 'Amazon',
    recipient_email: 'user@example.com',
    subject: 'Your order has been cancelled',
    body_plain: "Dear customer,\n\nYour recent order has been cancelled due to payment issues. Confirm your payment method now: http://bit.ly/amazon-fix\n\nAmazon Team",
    received_at: 2.days.ago,
    is_phishing: true,
    phishing_type: 'credential_harvest'
  },
  {
    sender_email: 'prize@lottery.tk',
    sender_name: 'Prize Notification',
    recipient_email: 'user@example.com',
    subject: 'Congratulations! You won $10,000',
    body_plain: "Dear winner,\n\nYou have been selected to receive $10,000. Click here to claim your prize immediately: http://lottery.tk/claim\n\nAct now before it expires!",
    received_at: 4.days.ago,
    is_phishing: true,
    phishing_type: 'social_engineering'
  },
  {
    sender_email: 'security@bankofamerica.ml',
    sender_name: 'Bank Security',
    recipient_email: 'user@example.com',
    subject: 'Suspicious login detected',
    body_plain: "Dear customer,\n\nWe detected a suspicious login attempt. Verify your identity now: http://goo.gl/bank-verify\n\nFailure to verify will result in account suspension.",
    received_at: 12.hours.ago,
    is_phishing: true,
    phishing_type: 'credential_harvest'
  }
])

puts "Created #{Email.count} emails (#{Email.phishing.count} phishing, #{Email.legitimate.count} legitimate)"
puts "\nDemo ready! Visit http://localhost:3000"
puts "Try reporting a suspicious email to see the phishing detection in action!"
