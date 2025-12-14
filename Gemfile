source "https://rubygems.org"

ruby ">= 3.4.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.6"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # Debugging
  gem "debug", platforms: %i[ mri windows ]

  # Testing frameworks
  gem "rspec-rails", "~> 6.0"
  gem "factory_bot_rails", "~> 6.2"
  gem "faker", "~> 3.2"
end

group :development do
  # Development web server
  gem "web-console"

  # Code quality
  gem "rubocop", "~> 1.50", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false

  # Security scanning
  gem "brakeman", "~> 6.0", require: false

  # Documentation
  gem "yard", require: false
end

group :test do
  # System testing
  gem "capybara", "~> 3.39"
  gem "selenium-webdriver", "~> 4.27"

  # BDD testing
  gem "cucumber-rails", "~> 3.1", require: false
  gem "cucumber", "~> 9.0"
  gem "database_cleaner-active_record"

  # Test coverage
  gem "simplecov", "~> 0.22", require: false

  # RSpec matchers
  gem "shoulda-matchers", "~> 5.0"
end

