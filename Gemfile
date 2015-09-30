source "https://rubygems.org"

ruby '2.2.2'

gem "rails", "~> 4"
gem "sass-rails"
gem "uglifier"
gem "coffee-rails"
gem "jquery-rails"
gem "bootstrap-sass"

gem 'pg'

gem "kaminari", "~> 0.15.1"

group :production do
  gem 'rails_12factor'
end

group :test, :development do
  gem "sqlite3"
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "capybara"
  gem "database_cleaner"
  gem "ruby_css_lint"
  gem "selenium-webdriver"
  gem "quiet_assets"
  gem 'simplecov', :require => false
end
