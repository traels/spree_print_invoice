source 'https://rubygems.org'

group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'
end

gem 'spree', github: 'spree/spree', branch: '2-1-stable'

# provides basic authentication functionality for testing parts of your engine
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '2-1-stable'
# provides basic i18n functionality for testing
gem 'spree_i18n', github: 'spree/spree_i18n', branch: '2-1-stable'

group :test do
  gem 'therubyracer', :platforms => :ruby
  gem 'capybara'
  gem 'capybara-screenshot', :require => false
  gem 'selenium-webdriver'
  gem 'factory_girl_rails', '~> 4.2'
end

gemspec
