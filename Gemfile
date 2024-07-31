# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.0'

# Use Rails 7.1.3 version or newer
gem 'rails', '~> 7.1.3', '>= 7.1.3.4'

# The original asset pipeline for Rails, providing support for serving static assets
gem 'sprockets-rails'

# Use PostgreSQL as the database for Active Record
gem 'pg', '~> 1.1'

# Puma web server for running the application
gem 'puma', '>= 5.0'

# JavaScript import maps for managing JavaScript dependencies
gem 'importmap-rails'

# Hotwire's page accelerator for creating single-page-like applications
gem 'turbo-rails'

# Hotwire's modest JavaScript framework for adding interactivity
gem 'stimulus-rails'

# Build JSON APIs easily with Jbuilder
gem 'jbuilder'

# Import data in batches with ActiveRecord
gem 'activerecord-import'

# Redis for caching and background job processing
gem 'redis'
gem 'sidekiq'
gem 'sidekiq-cron'

# Use tzinfo-data gem for timezone data on Windows and JRuby
gem 'tzinfo-data', platforms: %i[windows jruby]

# Bootsnap to reduce boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development, :test do
  # Debugging tools for development and testing environments
  gem 'debug', platforms: %i[mri windows]

  # Add RuboCop for static code analysis and style checking
  gem 'rubocop', require: false
end

group :development do
  gem 'error_highlight', '>= 0.6.0', platforms: [:ruby]

  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Rspec
  gem 'rspec-rails', '~> 5.0.0'

  # Factory bot
  gem 'factory_bot_rails'
  gem 'faker'

  # byebug
  gem 'byebug'

  # Ruby task_use progressbar
  gem 'ruby-progressbar'
end

group :test do
  # System testing tools
  gem 'capybara'
  gem 'selenium-webdriver'
end
