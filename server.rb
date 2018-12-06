require_relative 'management'
class Api < Sinatra::Base
  include HookDirection
  attr_accessor :params

  def initialize
    super
  end

  before do
    body = request.body.read
    @object = GithubResponceObjects.new(JSON.parse(body)) unless body == ''
    @params = JSON.parse(body) unless body == ''
  end

  get '/' do
    erb :index
  end

  post '/' do
    puts 'repository:'
    p @params['repository']['name']
    puts '--------------'
    puts 'branch'
    p @params['ref']
    puts '--------------'
    puts 'compare link:'
    p @params['compare']
    puts '--------------'
    puts 'commits'
    p @params['commits']
    result = find_action(@object)
    result.to_json
  end
end
