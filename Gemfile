source 'https://rubygems.org'

group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'
end

gem 'spree', '2.2.2'

# provides basic authentication functionality for testing parts of your engine
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '2-2-stable'
# provides basic i18n functionality for testing
gem 'spree_i18n', github: 'spree/spree_i18n', branch: '2-2-stable'

group :test do
  gem 'therubyracer', :platforms => :ruby
  gem 'capybara'
  gem 'rspec-rails', '2.14.2'
  gem 'capybara-screenshot', :require => false
  gem 'selenium-webdriver'
  gem 'factory_girl_rails', '~> 4.2'
end

gemspec
