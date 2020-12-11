# frozen_string_literal: true

require_relative 'author'
class Commit
  attr_accessor :id, :message, :url, :author

  def initialize(params)
    @id = params['id']
    @message = params['message']
    @timestamp = params['timestamp']
    @url = params['url']
    @author = Author.new(params)
  end
end
