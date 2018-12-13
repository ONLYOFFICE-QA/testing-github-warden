require_relative './management'
require_relative 'server'

run Rack::URLMap.new('/' => App)

configure do
  set :logger, Logger.new(STDOUT)
  set :server, :puma
  set :root, File.dirname(__FILE__)
  enable :static
  enable :dump_errors
  set :show_exceptions, false # uncomment for testing or production
  set :environment, ENV['RACK_ENV']
end
