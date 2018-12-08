require 'net/http'
require_relative '../../test_management'
class Http
  attr_accessor :http

  def initialize(options = {})
    options[:address] ||= StaticData::ADDRESS
    options[:port] ||= StaticData::PORT
    @http = Net::HTTP.new(options[:address], options[:port])
  end

  def post_request(params: nil, headers: {}, no_headers: false)
    request = Net::HTTP::Post.new('/')

    unless no_headers
      signature = generate_signature(params)
      headers['X-Hub-Signature'] ||= signature
      headers.each_pair do |header_name, value|
        request[header_name] = value
      end
    end
    request.body = params.to_json if params
    responce = @http.request(request)
    responce.body = JSON.parse(responce.body)
    responce
  end

  def generate_signature(params)
    'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], params.to_json)
  end
end
