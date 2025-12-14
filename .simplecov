# frozen_string_literal: true

SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/vendor/'
  add_filter '/features/'
  add_filter '/bin/'
  add_filter '/db/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
  add_group 'Decorators', 'app/decorators'
  add_group 'Repositories', 'app/repositories'
  add_group 'Helpers', 'app/helpers'

  # Reasonable coverage requirements for a demo project
  minimum_coverage 75

  enable_coverage :branch
end
