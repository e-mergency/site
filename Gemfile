source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '~> 3.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'sqlite3', '>= 1.3.5'

  # RSpec
  gem "rspec"
  gem "rspec-rails"

  # Cucmber
  gem "cucumber", "~> 1.0"
  gem "cucumber-rails", "~> 1.0", :require => false
  gem "database_cleaner"

  gem "jasmine", "~> 1"
  gem "ruby-debug19"

  gem "heroku"

  gem "guard"
  gem "guard-coffeescript"
end

# Mogoid
gem 'mongoid', ">= 3.1"

gem 'geocoder'
gem 'googlecharts'

# Use JQuery not prototype
gem 'jquery-rails'

# Gems required for user authentication
gem 'devise', ">= 2.2"
gem 'cancan'
gem 'css3buttons'

# Make web-editing smoother
gem "haml"
gem 'sass'
gem 'coffee-script'
gem 'uglifier'

# This is our JS executor if we don't have Node.js or similar
gem 'therubyracer-heroku', '0.8.1.pre3'
