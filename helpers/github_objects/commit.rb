# frozen_string_literal: true

require_relative 'commit/author'
# Class for describing commit information
class Commit
  # @return [String] id of commit
  attr_reader :id
  # @return [String] message of commit
  attr_reader :message
  # @return [String] url of commit on GitHub
  attr_reader :url
  # @return [Author] author object of commit
  attr_reader :author

  def initialize(params)
    @id = params['id']
    @message = params['message']
    @url = params['url']
    @author = Author.new(params)
  end
end
