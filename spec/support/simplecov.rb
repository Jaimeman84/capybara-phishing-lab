# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/vendor/'
  add_filter '/features/'

  add_group 'Services', 'app/services'
  add_group 'Decorators', 'app/decorators'
  add_group 'Repositories', 'app/repositories'

  minimum_coverage 100
  minimum_coverage_by_file 90
  refuse_coverage_drop

  # Enable branch coverage for more thorough testing
  enable_coverage :branch
end
