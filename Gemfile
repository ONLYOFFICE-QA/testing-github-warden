# frozen_string_literal: true

source 'https://rubygems.org'

ruby '>= 3.4.0'

gem 'logger', '~> 1'
gem 'ostruct', '~> 0'
gem 'redis', groups: %i[warden executioner]

group :warden do
  gem 'puma' # web server
  gem 'sinatra' # main web framework
  gem 'sinatra-contrib' # main web framework
end

group :executioner do
  gem 'onlyoffice_bugzilla_helper'
end

group :test do
  gem 'faker'
  gem 'rspec'
  gem 'simplecov', require: false
end

group :development do
  gem 'rake'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rake'
  gem 'rubocop-rspec'
end
