source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.1'

# Encryptation
gem 'bcrypt', '~> 3.1'

# Localization and message stardards
gem 'rails-i18n'

# Access tokens
gem 'jwt', '~> 2.10'

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem 'kamal', require: false

# Use postgres as the database for Active Record
gem 'pg', '~> 1.5'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Using CORS
gem 'rack-cors'

# Use the database-backed adapters for Rails.cache and Active Job
gem 'solid_cache'
gem 'solid_queue'

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false

  # Loads enviroment variables
  gem 'dotenv'

  # FactoryBot and Faker help creating objects for testing
  gem 'factory_bot_rails'
  gem 'faker', '~> 3.5'

  # rspec for automated testing
  gem 'rspec-rails'

  # rswag for testing
  gem 'rswag'

  # Rubocop plugins
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false

  # checking for test coverage
  gem 'simplecov', require: false
end
