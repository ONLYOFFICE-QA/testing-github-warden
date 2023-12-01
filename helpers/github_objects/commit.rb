# frozen_string_literal: true

require_relative 'commit/author'
# Class for describing commit information
class Commit
  # @return [Regexp] regexp for bug id with `bug` word including
  BUG_ID_REGEXP = /bug\s+#?(\d+)/
  # @return [Regexp] regexp for only finding digits
  DIGITS_REGEXP = /\d+/
  # @return [String] id of commit
  attr_reader :id
  # @return [String] message of commit
  attr_reader :message
  # @return [String] url of commit on GitHub
  attr_reader :url
  # @return [Author] author object of commit
  attr_reader :author

  # @param params [Hash] data to parse
  def initialize(params)
    @id = params['id']
    @message = params['message']
    @url = params['url']
    @author = Author.new(params['author'])
  end

  # Get bug id from commit message
  # @return [String, nil] bug id
  def bug_id
    @message.downcase[BUG_ID_REGEXP].to_s[DIGITS_REGEXP]
  end
end
