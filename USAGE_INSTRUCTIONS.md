# PhishingLab - Complete Usage Guide

## 🚀 Quick Start (3 Minutes)

### Get Running Fast

```bash
# Ensure you have Ruby 3.2+ installed
ruby --version

# Start the application (database is already set up!)
rails server
```

**That's it!** The database comes pre-loaded with 10 demo emails.

**Access the Application:**
- **Main Inbox:** http://localhost:3000
- **Admin Dashboard:** http://localhost:3000/admin/dashboard

---

## 📋 Detailed Setup (First Time Users)

If you need to set up from scratch or reset the database:

### Prerequisites
- Ruby 3.2+ installed
- Bundler installed
- SQLite3 installed

### Installation Steps

```bash
# 1. Install dependencies
bundle install

# 2. Set up database
rails db:create
rails db:migrate
rails db:seed

# 3. Start the application
rails server
```

The application will be available at: **http://localhost:3000**

---

## 📧 Using the Application

### Main Features

#### 1. **Email Inbox** (http://localhost:3000)
View all emails in a realistic corporate inbox with:
- Sender information (name + email)
- Subject lines
- Received dates
- Status badges (Reported/Unread)
- Risk level badges (Low/Medium/High/Critical) for analyzed emails

**How to use:**
- Browse the inbox (10 emails: 7 phishing, 3 legitimate)
- Click on any email to view full details
- Look for suspicious characteristics

#### 2. **Email Detail View**
Detailed view of individual emails showing:
- Full email content
- Sender details and timestamp
- "Report as Phishing" button (if not yet reported)
- Complete analysis results (after reporting)

**How to use:**
1. Click on an email from the inbox
2. Read the email content carefully
3. Click the **red "Report as Phishing"** button
4. Wait 1-2 seconds for automatic analysis
5. Review the results:
   - **Threat Score** (0-100)
   - **Risk Level** (Low/Medium/High/Critical)
   - **Detected Indicators** grouped by type
   - **Severity ratings** for each indicator

#### 3. **Admin Dashboard** (http://localhost:3000/admin/dashboard)
Analytics and metrics dashboard featuring:
- Total email statistics
- Reported email counts
- Risk distribution chart with color-coded bars
- Top 10 most common phishing indicators
- Detection effectiveness metrics

**How to access:**
- Click "Admin Dashboard" button in top-right of inbox
- Or navigate directly to `/admin/dashboard`

---

## 🎯 Demo Scenarios (2-Minute Walkthrough)

### Scenario 1: Detecting Credential Harvesting (High-Risk Phishing)

**Email:** "URGENT: Your account will be suspended"
**From:** Microsoft Security (security@micros0ft.com)

**Steps:**
1. Find and click this email in the inbox
2. Observe suspicious elements:
   - Generic greeting ("Dear customer")
   - Urgent/threatening language
   - Shortened URL (bit.ly)
   - **Sender domain spoofing** (micros0ft.com with '0' instead of 'o')
3. Click **"Report as Phishing"**
4. Review the analysis showing:
   - **High/Critical** threat score (likely 70-90)
   - URL indicators (shortened URL detected)
   - Content indicators (urgency language, credential request)
   - Sender indicators (domain spoofing, brand mismatch)

**Expected Outcome:** Critical/High risk rating (70-90 score) with multiple indicators

**Key Indicators Detected:**
- ✓ Urgency language
- ✓ URL shortener
- ✓ Credential request
- ✓ Domain spoofing (micros0ft.com)

---

### Scenario 2: Malware Delivery Detection

**Email:** "Invoice #45832 - Action Required"
**From:** Accounts Payable (supplier-company.xyz)

**Steps:**
1. Find and click this email
2. Notice suspicious elements:
   - Suspicious TLD (.xyz)
   - IP address in URL (192.168.1.100)
   - Executable file mention (.exe)
3. Click "Report as Phishing"
4. See indicators for:
   - Suspicious URL (IP-based, suspicious TLD)
   - Attachment-related content (executable)

**Expected Outcome:** High/Critical risk (70-90 score) with URL and attachment indicators

**Key Indicators Detected:**
- ✓ Suspicious .xyz domain
- ✓ IP address in URL
- ✓ Executable file mentioned

---

### Scenario 3: CEO Fraud (BEC) Detection

**Email:** "Urgent wire transfer needed"
**From:** CEO Office (ceo@gmail.com)

**Steps:**
1. Find and click this email
2. Observe:
   - CEO sending from free email (Gmail)
   - Unusual urgency
   - Request for financial action
3. Report and analyze
4. See indicators for:
   - Free email provider
   - Urgency language
   - Generic sender name

**Expected Outcome:** Medium/High risk (40-60 score) highlighting free email provider

**Key Indicators Detected:**
- ✓ CEO using Gmail
- ✓ Urgent financial request
- ✓ Generic sender

---

### Scenario 4: Legitimate Email (Low Risk)

**Email:** "Q4 Project Update"
**From:** john.smith@company.com

**Steps:**
1. Find and click this email
2. Notice professional characteristics:
   - Corporate email domain
   - Normal subject line
   - No urgency
   - Personalized sender
3. Report it anyway (to test false positive handling)
4. Observe:
   - **Low** threat score (0-20)
   - Few or no indicators
   - System correctly identifies as likely legitimate

**Expected Outcome:** Low risk score (0-20), minimal indicators

**Key Characteristics:**
- ✓ Corporate domain
- ✓ No urgency
- ✓ Normal content

---

## 🔍 Understanding the Detection Engine

### Phishing Indicators

The system detects 4 types of indicators:

#### 1. URL Indicators
- Suspicious TLDs (.tk, .ml, .ga, .xyz, etc.)
- URL shorteners (bit.ly, tinyurl.com, etc.)
- IP-based URLs
- Mismatched domains

#### 2. Sender Indicators
- Free email providers (gmail.com, yahoo.com, etc.)
- Generic sender names (admin, support, no-reply)
- Suspicious domain TLDs (.tk, .ml, .xyz, etc.)
- IP-based sender addresses
- Domain spoofing/typosquatting (micros0ft.com instead of microsoft.com)
- Brand name mismatch (claims to be from Microsoft but uses different domain)
- Excessive numbers in domain name

#### 3. Content Indicators
- Urgency language ("urgent", "immediate", "expire")
- Credential requests ("password", "verify account")
- Generic greetings ("Dear customer")

#### 4. Attachment Indicators
- Executable files (.exe, .scr, .bat)
- Suspicious attachments (.zip, .rar)
- Password-protected archives

### Threat Scoring System

Scores are calculated by adding weights for detected indicators:

- **Low severity:** +5 points
- **Medium severity:** +10-15 points
- **High severity:** +15-25 points
- **Critical severity:** +25-30 points

**Risk Levels:**
- **0-25:** Low Risk (likely legitimate)
- **26-50:** Medium Risk (suspicious, investigate)
- **51-75:** High Risk (likely phishing)
- **76-100:** Critical Risk (definite phishing)

---

## 📊 Admin Dashboard Features

### Statistics Cards
- **Total Emails:** All emails in the system
- **Reported Emails:** Emails that have been analyzed
- **Confirmed Phishing:** Emails classified as phishing

### Risk Distribution Chart
- Visual breakdown of emails by risk level
- Percentage and count for each level
- Color-coded bars:
  - 🟢 Green (Low)
  - 🟡 Yellow (Medium)
  - 🟠 Orange (High)
  - 🔴 Red (Critical)

### Top 10 Indicators
- Most frequently detected indicators
- Helps identify common phishing patterns
- Useful for security awareness training

---

## 🧪 Testing the Application

### Run All Tests

```bash
# RSpec unit and integration tests
bundle exec rspec

# Cucumber BDD scenarios
bundle exec cucumber

# Run both
bundle exec rake
```

### View Test Coverage

```bash
# After running RSpec
open coverage/index.html

# On Windows
start coverage/index.html
```

### Check Code Quality

```bash
# Run RuboCop style checker
bundle exec rubocop

# Auto-fix violations
bundle exec rubocop -a

# Security scan
bundle exec brakeman
```

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

### No emails showing?
```bash
rails db:seed
```

### Application won't start?
```bash
# Ensure database exists
rails db:create
rails db:migrate
rails db:seed
```

### Database errors?
```bash
# Reset database
rails db:drop db:create db:migrate db:seed
```

### Tests failing?
```bash
# Prepare test database
RAILS_ENV=test rails db:migrate

# Run specific test
bundle exec rspec spec/models/email_spec.rb
```

---

## 🎭 Demo Talking Points

When presenting this project:

### 1. Architecture
- "I implemented SOLID principles throughout - each analyzer has a single responsibility"
- "Used service objects to keep controllers thin and logic testable"
- "Follows Rails conventions with custom enhancements for enterprise patterns"

### 2. Testing
- "Achieved comprehensive test coverage using RSpec, Capybara, and Cucumber"
- "Wrote BDD scenarios that non-technical stakeholders can read"
- "Used FactoryBot for maintainable test data"

### 3. Domain Knowledge
- "Researched actual phishing tactics from industry knowledge bases"
- "Implemented realistic detection algorithms based on industry standards"
- "Created weighted scoring system similar to enterprise threat platforms"

### 4. Code Quality
- "Zero RuboCop violations"
- "Security scanned with Brakeman - no vulnerabilities"
- "Comprehensive documentation and ADRs for architectural decisions"

### 5. Technical Stack Highlights
- Ruby on Rails 7.1
- SQLite database
- Tailwind CSS (via CDN)
- Professional MVC architecture
- Service object pattern
- Repository pattern (planned)

---

## 📝 Key Routes

| Route | Purpose |
|-------|---------|
| `/` or `/emails` | Email inbox (main page) |
| `/emails/:id` | View email details |
| `/reports` (POST) | Report email as phishing |
| `/admin/dashboard` | Admin analytics dashboard |

---

## 🔐 Security Features

- CSRF protection enabled
- SQL injection prevention (parameterized queries)
- XSS protection (sanitized output)
- No authentication required (demo purposes)
- Input validation on all models

---

## 💡 Tips for Best Demo Experience

1. **Start with legitimate email** - Show the system doesn't flag everything
2. **Demonstrate high-risk phishing** - Show multiple indicators detected
3. **Walk through the analysis** - Explain each indicator type
4. **Show admin dashboard** - Demonstrate metrics and reporting
5. **Highlight code architecture** - Open codebase to show SOLID principles

---

## 💡 Key Features to Highlight

### For SDET Interview:
- ✅ **SOLID Principles** - See `app/services/phishing_detection/` for SRP/OCP examples
- ✅ **Clean Architecture** - Controllers → Services → Models separation
- ✅ **Test Framework** - RSpec, Capybara, Cucumber configured
- ✅ **Security** - CSRF, XSS protection, input validation
- ✅ **Documentation** - Comprehensive guides and planning docs

---

## 📚 Additional Resources

- [README.md](README.md) - Project overview and setup
- [QUICKSTART.md](QUICKSTART.md) - Ultra-quick reference
- [workflow.mdc](workflow.mdc) - Development workflow
- [brd.mdc](brd.mdc) - Business requirements
- [ard.mdc](ard.mdc) - Architecture details
- [folder-structure.mdc](folder-structure.mdc) - Code organization

---

## 🎉 Next Steps

After mastering the basic demo:

1. **Try All Demos** - Report all 7 phishing emails
2. **Compare Scores** - See how different tactics rate
3. **View Dashboard** - Review analytics after reporting multiple emails
4. **Test False Positives** - Try reporting legitimate emails (low score expected)
5. **Explore Code** - Check out `app/services/phishing_detection/`
6. **Run Tests** - Execute `bundle exec rspec` and `bundle exec cucumber`
7. **Check Coverage** - Open `coverage/index.html`
8. **Read Architecture** - See [ard.mdc](ard.mdc) for design details

---

## 📍 Database Location

The SQLite database files are located in the `storage` directory:

- **Development database:** `storage/development.sqlite3`
- **Test database:** `storage/test.sqlite3`
- **Production database:** `storage/production.sqlite3`

You can access these databases using:
- **DB Browser for SQLite** (GUI tool)
- **sqlite3 CLI:** `sqlite3 storage/development.sqlite3`
- **Rails console:** `rails console`
- **Rails dbconsole:** `rails dbconsole`

---

**Ready to demo!** 🚀

For questions or issues, refer to the comprehensive documentation in the project root.
