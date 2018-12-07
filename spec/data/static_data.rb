require_relative '../../spec/data/abstract_request'
class StaticData
  extend AbstractRequest
  ADDRESS = '0.0.0.0'.freeze
  PORT = 3000
  MAINPAGE = "http://#{ADDRESS}:#{PORT}".freeze
  SECRET_TOKEN = '12345'.freeze
  WRONG_HTTP_X_HUB_SIGNATURE = 'sha1=wrong_key'.freeze
  BUG_ID_TEST = '39463'.freeze
end
