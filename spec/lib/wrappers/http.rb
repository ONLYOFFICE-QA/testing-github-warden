require 'net/http'
require_relative '../../test_management'
class Http
  attr_accessor :http, :secret

  def initialize(options = {})
    options[:address] ||= StaticData::ADDRESS
    options[:port] ||= StaticData::PORT
    @http = Net::HTTP.new(options[:address], options[:port])
    # @secret = token
  end

  def post_request(params = nil)
    request = Net::HTTP::Post.new('/')
    request.body = params.to_json if params
    responce = @http.request(request)
    responce.body = JSON.parse(responce.body)
    responce
  end
end
