# frozen_string_literal: true

# Class for storing data about author
class Author
  # @return [String] human name of author
  attr_reader :name
  # @return [String] email of author
  attr_reader :email
  # @return [String] username like on GitHub
  attr_reader :username

  # @param params [Hash] data to parse
  def initialize(params)
    @name = params['name']
    @email = params['email']
    @username = params['username']
  end
end
