# frozen_string_literal: true

require_relative 'helpers/hook_detection'
require_relative 'helpers/request_token'
require_relative 'management'
class App < Sinatra::Base
  helpers Sinatra::CustomLogger
  attr_accessor :params

  def initialize
    @version = '0.1.3'
    @allowed_branch_parser = AllowedBranchesParser.new
    super
  end

  before do
    body = request.body.read
    @redis = Redis.new(path: 'tmp/redis/redis.sock')
    @object = GithubResponceObjects.new(JSON.parse(body)) unless body == ''
    @params = JSON.parse(body) unless body == ''
  end

  configure do
    logger = Logger.new($stdout)
    logger.level = Logger::DEBUG if development?
    set :logger, logger
  end

  get '/' do
    @secret_token = !ENV['SECRET_TOKEN'].nil?
    @commits_count = @redis.lrange('github_warden_action', 0, -1).size
    @redis_ping = @redis.ping == 'PONG'
    erb :index
  end

  post '/' do
    request.body.rewind
    verify_signature
    if @object.commits
      result = HookDetection.new(@object).find_action
      @redis.lpush 'github_warden_action', result.to_json
      logger.info "-> New result: #{result.to_json}"
      result.to_json
    else
      nil.to_json
    end
  end

  def verify_signature
    token = RequestToken.new(request)
    halt 500, { errors: ['No HTTP_X_HUB_SIGNATURE or HTTP_X_GITLAB_TOKEN'] }.to_json unless token.sender_type
    halt 500, { errors: ['No SECRET_TOKEN'] }.to_json unless ENV['SECRET_TOKEN']
    halt 500, { errors: ['Wrong signatures'] }.to_json unless Rack::Utils.secure_compare(token.warden_signature, token.request_signature)
  end
end
