require_relative 'management'
class Api < Sinatra::Base
  attr_accessor :params

  def initialize
    super
  end

  before do
    body = request.body.read
    @params = JSON.parse(body) unless body == ''
  end

  get '/' do
    erb :index
  end

  post '/' do
    p @params.to_s
  end
end
