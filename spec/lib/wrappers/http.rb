# frozen_string_literal: true

require 'net/http'
require 'spec_helper'

class Http
  # @return [String] default address for http server
  DEFAULT_ADDRESS = '0.0.0.0'
  # @return [Integer] default port for http server
  DEFAULT_PORT = 3000
  attr_accessor :http

  def initialize(options = {})
    options[:address] ||= DEFAULT_ADDRESS
    options[:port] ||= DEFAULT_PORT
    @http = Net::HTTP.new(options[:address], options[:port])
  end

  def post_request(params: nil, headers: {}, generate_signature: true)
    request = Net::HTTP::Post.new('/')

    if generate_signature
      signature = generate_signature(params)
      headers['X_HUB_SIGNATURE'] ||= signature
    end
    headers.each_pair do |header_name, value|
      request[header_name] = value
    end
    request.body = params.to_json if params
    responce = @http.request(request)
    responce.body = JSON.parse(responce.body)
    responce
  end

  def generate_signature(params)
    "sha1=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV.fetch('SECRET_TOKEN', ''), params.to_json)}"
  end
end
