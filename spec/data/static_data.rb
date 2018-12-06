require_relative '../../spec/data/abstract_request'
class StaticData
  extend AbstractRequest
  ADDRESS = '0.0.0.0'.freeze
  PORT = 9292
  MAINPAGE = "http://#{ADDRESS}:#{PORT}".freeze
end
