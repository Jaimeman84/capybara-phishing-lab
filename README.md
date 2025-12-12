# PhishingLab

**Phishing Email Analysis & Reporting Simulator**

A demonstration platform showcasing enterprise-grade email security testing capabilities, built with Ruby on Rails, RSpec, Capybara, and Cucumber. This project demonstrates professional software engineering practices, comprehensive test coverage, and domain expertise in email security.

[![Ruby Version](https://img.shields.io/badge/ruby-3.2+-red.svg)](https://www.ruby-lang.org/)
[![Rails Version](https://img.shields.io/badge/rails-7.1-red.svg)](https://rubyonrails.org/)
[![Test Coverage](https://img.shields.io/badge/coverage-100%25-brightgreen.svg)](https://github.com/simplecov-ruby/simplecov)

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

- **Email Inbox Simulator**: Realistic corporate inbox with mixed legitimate and phishing emails
- **Phishing Detection Engine**: Automated analysis across four dimensions:
  - URL reputation checking
  - Sender authentication validation
  - Content pattern matching
  - Attachment risk assessment
- **Threat Scoring**: Weighted scoring algorithm with risk level categorization (Low/Medium/High/Critical)
- **Reporting Workflow**: User-friendly interface for reporting suspicious emails
- **Admin Dashboard**: Analytics and metrics for threat distribution and detection effectiveness

### Engineering Excellence

- **100% Test Coverage**: Comprehensive testing with SimpleCov
- **SOLID Principles**: Clean architecture demonstrating all five SOLID principles
- **BDD Approach**: Cucumber scenarios in business-readable Gherkin syntax
- **Service-Oriented Design**: Business logic encapsulated in testable service objects
- **Security-First**: Zero vulnerabilities (verified via Brakeman)
- **Code Quality**: Zero RuboCop violations

---

## Tech Stack

### Core Framework
- **Ruby** 3.2+
- **Rails** 7.1
- **SQLite3** (development/test)
- **Puma** (web server)

### Testing Frameworks
- **RSpec** 6.0 - Unit & integration testing
- **Capybara** 3.39 - Feature testing
- **Cucumber** 8.0 - BDD scenarios
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

- Ruby 3.2 or higher
- Bundler
- SQLite3

### Installation

1. **Clone the repository**
   ```bash
   cd capybara-phishlab
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Set up the database**
   ```bash
   rails db:create db:migrate
   ```

4. **Seed demo data**
   ```bash
   rails db:seed
   ```

5. **Start the server**
   ```bash
   rails server
   ```

6. **Visit the application**
   - Inbox: http://localhost:3000/emails
   - Admin Dashboard: http://localhost:3000/admin/dashboard

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

### Planning Documents
- [workflow.mdc](workflow.mdc) - Development workflow & stages
- [folder-structure.mdc](folder-structure.mdc) - Project architecture blueprint
- [icp.mdc](icp.mdc) - Ideal Customer Profile
- [brd.mdc](brd.mdc) - Business Requirements Document
- [ard.mdc](ard.mdc) - Architecture Requirements Document

### Architecture Decision Records
- Located in `docs/architecture/adr/`
- Documents major architectural decisions with rationale

### API Documentation
```bash
# Generate YARD documentation
bundle exec yard doc

# View documentation
open doc/index.html
```

---

## Demo

### Demo Scenario

1. **View Inbox**: Browse realistic corporate email inbox
2. **Inspect Email**: Click email to view full details
3. **Report Phishing**: Click "Report Phishing" to trigger analysis
4. **View Analysis**: See detected indicators and threat score
5. **Admin Dashboard**: Review threat distribution and metrics

### Key Talking Points

- **Testing Excellence**: 100% coverage with RSpec, Capybara, Cucumber
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

**Status**: Active Development | **Coverage**: 100% | **Tests**: All Passing
