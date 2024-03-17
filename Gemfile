# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

gem 'rails', '~> 7.1.3', '>= 7.1.3.2'
# FIXME: Workaround for FrozenError: can't modify frozen String: ""
# c.f. https://github.com/mastodon/mastodon-api/issues/49
# gem "mastodon-api", require: "mastodon"
gem "mastodon-api", require: "mastodon", github: "ashphy/mastodon-api", branch: "master", ref: "69adfb4" # https://github.com/ashphy/mastodon-api/commit/69adfb4f6c4fd77874e4a3f6f3e335aecbf3c794
gem 'nokogiri'
gem 'pg'
gem 'puma', '>= 5.0'

gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'bootsnap', require: false
gem 'service_actor-rails', '~> 1'
gem 'whenever'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'debug', platforms: %i[mri windows]
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rspec-rails'
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

gem "dockerfile-rails", ">= 1.6", group: :development
