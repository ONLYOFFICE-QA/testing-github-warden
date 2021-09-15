# frozen_string_literal: true

# Class for storing data about author
class Author
  # @return [String] human name of author
  attr_reader :name
  # @return [String] email of author
  attr_reader :email
  # @return [String] username like on GitHub
  attr_reader :username

  def initialize(params)
    @name = params['author']['name']
    @email = params['author']['email']
    @username = params['author']['username']
  end
end
