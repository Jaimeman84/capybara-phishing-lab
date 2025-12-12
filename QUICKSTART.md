# 🚀 PhishingLab - Quick Start Guide

## Get the App Running in 3 Minutes!

### Step 1: Ensure Dependencies Are Installed
```bash
# You should already have these, but verify:
ruby --version   # Should be 3.2+
bundle --version # Should be installed
```

### Step 2: Start the Application
```bash
# From the project directory:
rails server
```

**That's it!** The database is already set up with 10 demo emails.

---

## 📧 Access the Application

Open your browser and go to:
- **Main Inbox:** http://localhost:3000
- **Admin Dashboard:** http://localhost:3000/admin/dashboard

---

## 🎯 Try the Demo (2-Minute Walkthrough)

### 1. View the Inbox
- You'll see 10 emails (7 phishing, 3 legitimate)
- Notice different sender names, subjects, and dates
- Some show "Reported" status and risk levels

### 2. Report a Phishing Email
1. Click on: **"URGENT: Your account will be suspended"**
   - From: Microsoft Security
2. Read the email (notice suspicious elements)
3. Click the **red "Report as Phishing"** button
4. Wait 1-2 seconds for analysis
5. **Review the Results:**
   - Threat Score (likely 60-80)
   - Risk Level (High or Critical)
   - Detected Indicators:
     - URL indicators (bit.ly shortener)
     - Content indicators (urgency language, credential request)
     - Sender indicators

### 3. View the Admin Dashboard
1. Click "Admin Dashboard" (top right)
2. See statistics:
   - Total emails: 10
   - Reported emails: (number you've reported)
   - Risk distribution chart
   - Top 10 detected indicators

---

## 🧪 Quick Test Run

Want to verify the test framework is working?

```bash
# Run RSpec tests (some placeholder tests exist)
bundle exec rspec

# Check code quality
bundle exec rubocop

# Security scan
bundle exec brakeman
```

---

## 🎬 Demo Scenarios

### Scenario 1: High-Risk Phishing
**Email:** "URGENT: Your account will be suspended"
- Has urgency language ✓
- Uses URL shortener ✓
- Requests credentials ✓
- **Expected:** High/Critical risk (60-80 score)

### Scenario 2: Malware Delivery
**Email:** "Invoice #45832 - Action Required"
- Suspicious .xyz domain ✓
- IP address in URL ✓
- Mentions executable file ✓
- **Expected:** High/Critical risk (70-90 score)

### Scenario 3: CEO Fraud (BEC)
**Email:** "Urgent wire transfer needed"
- CEO using Gmail ✓
- Urgent financial request ✓
- Generic sender ✓
- **Expected:** Medium/High risk (40-60 score)

### Scenario 4: Legitimate Email
**Email:** "Q4 Project Update"
- Corporate domain ✓
- No urgency ✓
- Normal content ✓
- **Expected:** Low risk (0-20 score)

---

## 📊 What You'll See

### Email Inbox
- Table with 10 emails
- Sender info (name + email)
- Subject lines
- Received dates
- Status badges (Reported/Unread)
- Risk level badges (color-coded)

### Email Detail Page
- Full email content
- Sender details
- "Report as Phishing" button (if not reported)
- Analysis results (if reported):
  - Threat score with risk level badge
  - Grouped indicators by type
  - Severity ratings for each indicator

### Admin Dashboard
- 3 stat cards (Total/Reported/Phishing)
- Risk distribution chart with color bars
- Top 10 indicators list with counts

---

## 🔧 Troubleshooting

### Port 3000 already in use?
```bash
# Use a different port
rails server -p 3001
# Then visit: http://localhost:3001
```

### Want to reset the demo data?
```bash
rails db:seed
# This clears and reloads the 10 demo emails
```

### Application won't start?
```bash
# Ensure database exists
rails db:create
rails db:migrate
rails db:seed
```

---

## 📚 Next Steps

1. **Try All Demos** - Report all 7 phishing emails
2. **View Dashboard** - See analytics after reporting multiple emails
3. **Explore Code** - Check out `app/services/phishing_detection/`
4. **Read Full Docs** - See [USAGE_INSTRUCTIONS.md](USAGE_INSTRUCTIONS.md)
5. **Review Architecture** - Check [ard.mdc](ard.mdc) for design details

---

## 💡 Key Features to Highlight

### For SDET Interview:
- ✅ **SOLID Principles** - See `app/services/phishing_detection/` for SRP/OCP examples
- ✅ **Clean Architecture** - Controllers → Services → Models separation
- ✅ **Test Framework** - RSpec, Capybara, Cucumber configured
- ✅ **Security** - CSRF, XSS protection, input validation
- ✅ **Documentation** - Comprehensive guides and planning docs

### Technical Stack:
- Ruby on Rails 7.1
- SQLite database
- Tailwind CSS (via CDN)
- Professional MVC architecture
- Service object pattern
- Repository pattern (planned)

---

## 🎉 You're Ready!

The application is fully functional. Start exploring and enjoy the demo!

**Questions?** Check [USAGE_INSTRUCTIONS.md](USAGE_INSTRUCTIONS.md) for detailed documentation.

**Happy demoing!** 🚀
