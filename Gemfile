source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
gem 'figaro'
gem 'faraday'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'bootstrap-sass'
gem 'geocoder'
gem 'google_maps_service'

gem 'responders'




gem 'sass-rails'
gem 'stripe'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :production do
  gem 'rails_12factor'
  gem 'fog'
end

group :production, :development do
  gem 'aws-sdk'
  gem 'aws-sdk-v1'
  gem 'carrierwave'
  gem 'mini_magick'
  gem 'gmaps4rails'
  gem 'markerclustererplus-rails'
end

group :development, :test do
  gem 'pry-rails'
  gem 'parallel_tests'
end

group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'simplecov', require: false
  gem 'selenium-webdriver', '~> 2.53.4'
  gem 'chromedriver-helper'
  gem 'rspec-wait'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
