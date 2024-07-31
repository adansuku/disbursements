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

# Progress bar for Ruby
gem 'ruby-progressbar'

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

# Uncomment the following lines if needed:
# Use Redis adapter to run Action Cable in production
# gem 'redis', '>= 4.0.1'

# Use Kredis to get higher-level data types in Redis
# gem 'kredis'

# Active Model has_secure_password for secure password handling
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage for image processing (if needed)
# gem 'image_processing', '~> 1.2'

group :development, :test do
  # Debugging tools for development and testing environments
  gem 'debug', platforms: %i[mri windows]

  # Add RuboCop for static code analysis and style checking
  gem 'rubocop', require: false
end

group :development do
  # Console for handling exceptions in development
  gem 'web-console'

  # Uncomment to add speed badges for performance profiling
  # gem 'rack-mini-profiler'

  # Uncomment to speed up commands on slow machines or large apps
  # gem 'spring'
end

group :test do
  # System testing tools
  gem 'capybara'
  gem 'selenium-webdriver'
end
