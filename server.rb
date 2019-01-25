require_relative 'management'
class App < Sinatra::Base
  helpers Sinatra::CustomLogger
  include HookDirection
  attr_accessor :params

  def initialize
    @version = '0.0.2'
    super
  end

  before do
    body = request.body.read
    @object = GithubResponceObjects.new(JSON.parse(body)) unless body == ''
    @params = JSON.parse(body) unless body == ''
  end


  configure do
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG if development?
    set :logger, logger
  end

  get '/' do
    @secret_token = !ENV['SECRET_TOKEN'].nil?
    @secret_api_key = !ENV['BUGZILLA_API_KEY'].nil?
    @threads_count = Thread.list.select { |thread| thread.status == 'run' }.count
    erb :index
  end

  post '/' do
    request.body.rewind
    payload_body = request.body.read
    verify_signature(payload_body)
    result = find_action(@object) if @object.commits
    logger.info "-> New result: #{result}"
    result.to_json
  end

  def verify_signature(payload_body)
    halt 500, { errors: ['No HTTP_X_HUB_SIGNATURE'] }.to_json unless request.env['HTTP_X_HUB_SIGNATURE']
    halt 500, { errors: ['No SECRET_TOKEN'] }.to_json unless ENV['SECRET_TOKEN']
    signature = 'sha1=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), ENV['SECRET_TOKEN'], payload_body)
    halt 500, { errors: ['Wrong signatures'] }.to_json unless Rack::Utils.secure_compare(signature, request.env['HTTP_X_HUB_SIGNATURE'])
  end
end
