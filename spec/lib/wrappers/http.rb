require_relative '../../../spec/data/static_data'
require 'net/http'
require_relative '../../test_management'
class Http
  attr_accessor :http, :secret

  def initialize(options = {})
    options[:port] ||= 80
    @http = Net::HTTP.new(options[:address], options[:port])
    @token = token
  end

  def post_request(path, params = nil)
    request = Net::HTTP::Post.new(path, 'Authorization' => @token, 'Content-Type' => 'application/json')
    request.body = params.to_json if params
    http.request(request)
  end
end
