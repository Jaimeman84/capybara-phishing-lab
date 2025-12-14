# PhishingLab

**Phishing Email Analysis & Reporting Simulator**

A demonstration platform showcasing enterprise-grade email security testing capabilities, built with Ruby on Rails, RSpec, Capybara, and Cucumber. This project demonstrates professional software engineering practices, comprehensive test coverage, and domain expertise in email security.

[![Ruby Version](https://img.shields.io/badge/ruby-3.4+-red.svg)](https://www.ruby-lang.org/)
[![Rails Version](https://img.shields.io/badge/rails-7.1-red.svg)](https://rubyonrails.org/)
[![Test Coverage](https://img.shields.io/badge/coverage-90%25+-brightgreen.svg)](https://github.com/simplecov-ruby/simplecov)

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Running Tests](#running-tests)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Documentation](#documentation)
- [Demo](#demo)

---

## Features

### Core Functionality

- **Email Inbox Simulator**: Realistic corporate inbox with 10 demo emails (7 phishing, 3 legitimate)
- **Phishing Detection Engine**: Automated analysis across four dimensions:
  - URL reputation checking (suspicious TLDs, shorteners, IP addresses)
  - Sender authentication validation (domain spoofing, free email providers, brand mismatch)
  - Content pattern matching (urgency language, credential requests, generic greetings)
  - Attachment risk assessment (executable files, suspicious archives)
- **Threat Scoring**: Weighted scoring algorithm with risk level categorization (Low/Medium/High/Critical)
- **Reporting Workflow**: User-friendly interface for reporting suspicious emails
- **Admin Dashboard**: Real-time analytics showing threat distribution and top 10 indicators

### Engineering Excellence

- **Comprehensive Test Coverage**: 23 Cucumber scenarios (23 passed), 117 steps (117 passed)
- **SOLID Principles**: Clean architecture demonstrating all five SOLID principles
- **BDD Approach**: Cucumber scenarios in business-readable Gherkin syntax
- **Service-Oriented Design**: Business logic encapsulated in testable service objects
- **Security-First**: Zero vulnerabilities (verified via Brakeman)
- **Modern UI**: Tailwind CSS via CDN with responsive design

---

## Tech Stack

### Core Framework
- **Ruby** 3.4.7
- **Rails** 7.1.6
- **SQLite3** (development/test)
- **Puma** (web server)

### Testing Frameworks
- **RSpec** 6.0 - Unit & integration testing
- **Capybara** 3.39 - Feature testing
- **Cucumber** 9.0 - BDD scenarios
- **Selenium WebDriver** 4.27 - Browser automation
- **SimpleCov** 0.22 - Code coverage
- **FactoryBot** 6.2 - Test data generation
- **Faker** 3.2 - Realistic fake data

### Code Quality & Security
- **RuboCop** 1.50 - Ruby style enforcement
- **Brakeman** 6.0 - Security vulnerability scanning
- **Shoulda Matchers** 5.0 - RSpec matchers

---

## Getting Started

### Prerequisites

- Ruby 3.4 or higher
- Bundler
- SQLite3

### Quick Start (30 Seconds)

```bash
# The database is already set up with 10 demo emails!
rails server
```

**Access the application:**
- **Main Inbox:** http://localhost:3000
- **Admin Dashboard:** http://localhost:3000/admin/dashboard

### First Time Setup

If you need to reset or set up from scratch:

```bash
# Install dependencies
bundle install

# Set up the database
rails db:create db:migrate db:seed

# Start the server
rails server
```

**See [QUICKSTART.md](QUICKSTART.md) for the ultra-quick reference or [USAGE_INSTRUCTIONS.md](USAGE_INSTRUCTIONS.md) for the complete guide.**

---

## Running Tests

### Run All Tests

```bash
# RSpec tests
bundle exec rspec

# Cucumber scenarios
bundle exec cucumber

# Both
bundle exec rake
```

### Test Coverage

```bash
# Generate coverage report
bundle exec rspec
open coverage/index.html
```

### Code Quality

```bash
# Run RuboCop
bundle exec rubocop

# Auto-fix violations
bundle exec rubocop -a

# Security scan
bundle exec brakeman
```

---

## Project Structure

```
capybara-phishlab/
├── app/
│   ├── controllers/          # HTTP request handling
│   ├── models/               # Domain models & validations
│   ├── services/             # Business logic (SOLID)
│   │   └── phishing_detection/  # Detection analyzers
│   ├── decorators/           # Presentation logic
│   ├── repositories/         # Data access layer
│   └── views/                # Templates
├── spec/
│   ├── models/               # Model unit tests
│   ├── services/             # Service unit tests
│   ├── requests/             # Integration tests
│   ├── features/             # Capybara feature tests
│   ├── factories/            # FactoryBot factories
│   ├── fixtures/             # Test email samples
│   └── support/              # Test configuration
├── features/                 # Cucumber BDD scenarios
│   ├── step_definitions/     # Gherkin step implementations
│   └── support/              # Cucumber configuration
├── db/
│   ├── migrate/              # Database migrations
│   └── seeds/                # Demo data seeds
├── docs/
│   └── architecture/adr/     # Architecture Decision Records
├── *.mdc                     # Project planning documents
└── README.md                 # This file
```

---

## Architecture

### SOLID Principles

**Single Responsibility Principle (SRP)**
- Each analyzer handles one type of detection (URL, sender, content, attachment)
- Controllers handle HTTP concerns only
- Services contain business logic for a single domain concept

**Open/Closed Principle (OCP)**
- `BaseAnalyzer` abstract class allows new analyzers without modifying existing code
- Strategy pattern for threat scoring allows new algorithms

**Liskov Substitution Principle (LSP)**
- All analyzers inherit from `BaseAnalyzer` and implement the same interface
- `PhishingDetectionService` can use any analyzer interchangeably

**Interface Segregation Principle (ISP)**
- Small, focused concerns (Scorable, Reportable) instead of one large concern
- Models include only the concerns they actually need

**Dependency Inversion Principle (DIP)**
- Controllers depend on service interfaces, not implementations
- Services use dependency injection for analyzers

### Design Patterns

- **Service Object Pattern**: Business logic encapsulation
- **Repository Pattern**: Data access abstraction
- **Decorator Pattern**: Presentation logic separation
- **Strategy Pattern**: Algorithm selection at runtime
- **Facade Pattern**: `PhishingDetectionService` orchestrator

### Database Schema

```
Emails
  ├── has_one :report
  ├── has_many :phishing_indicators
  └── has_one :threat_score

PhishingIndicators
  └── belongs_to :email

ThreatScores
  └── belongs_to :email

Reports
  └── belongs_to :email
```

---

## Documentation

### User Guides
- **[QUICKSTART.md](QUICKSTART.md)** - Get running in 30 seconds
- **[USAGE_INSTRUCTIONS.md](USAGE_INSTRUCTIONS.md)** - Complete usage guide with demo scenarios

### Planning Documents
- [workflow.mdc](workflow.mdc) - Development workflow & stages (all completed ✅)
- [folder-structure.mdc](folder-structure.mdc) - Project architecture blueprint
- [icp.mdc](icp.mdc) - Ideal Customer Profile
- [brd.mdc](brd.mdc) - Business Requirements Document
- [ard.mdc](ard.mdc) - Architecture Requirements Document

---

## Demo

### Demo Scenario

1. **View Inbox**: Browse realistic corporate email inbox
2. **Inspect Email**: Click email to view full details
3. **Report Phishing**: Click "Report Phishing" to trigger analysis
4. **View Analysis**: See detected indicators and threat score
5. **Admin Dashboard**: Review threat distribution and metrics

### Key Talking Points

- **Testing Excellence**: Comprehensive 90%+ coverage with RSpec, Capybara, Cucumber
- **SOLID Principles**: Clean architecture throughout codebase
- **Domain Knowledge**: Understanding of real-world phishing tactics
- **Professional Quality**: Production-ready code standards
- **BDD Approach**: Business-readable Cucumber scenarios

---

## Testing Philosophy

### Test Pyramid

```
        /\
       /  \      E2E Tests (Cucumber)
      /____\     Few, slow, high-value scenarios
     /      \
    /        \   Integration Tests (Capybara)
   /__________\  Medium number, user workflows
  /            \
 /              \  Unit Tests (RSpec)
/________________\ Many, fast, comprehensive coverage
```

**Distribution:**
- Unit Tests: 70% (models, services, helpers)
- Integration Tests: 20% (requests, features)
- E2E Tests: 10% (cucumber scenarios)

---

## Security

All code has been scanned with:
- **Brakeman**: Static security analysis
- **Bundler Audit**: Dependency vulnerability checking
- **Manual Review**: OWASP Top 10 checklist

---

## License

This project is a demonstration/portfolio project.

---

## Contact

Built to demonstrate SDET skills including:
- Test automation framework design
- Comprehensive test coverage
- Clean code architecture
- Security domain knowledge
- Professional documentation

---

**Status**: ✅ Completed & Demo-Ready | **Tests**: 23/23 Scenarios Passing (117/117 steps) | **Database**: Pre-loaded with 10 demo emails

---

## 🎯 Quick Demo

1. Start the server: `rails server`
2. Visit http://localhost:3000
3. Click on **"URGENT: Your account will be suspended"**
4. Click **"Report as Phishing"**
5. See threat analysis with detected indicators
6. Visit **Admin Dashboard** for analytics

**Ready to impress!** 🚀
