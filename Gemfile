# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'rails', '~> 7.1.3', '>= 7.1.3.2'

gem 'pg'
gem 'puma', '>= 5.0'

gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'bootsnap', require: false
gem 'httparty'
gem 'service_actor-rails', '~> 1'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'debug', platforms: %i[mri windows]
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
