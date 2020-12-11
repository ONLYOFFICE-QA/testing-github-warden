# frozen_string_literal: true

require_relative 'author'
class Author
  attr_accessor :name, :email, :username

  def initialize(params)
    @name = params['author']['name']
    @email = params['author']['email']
    @username = params['author']['username']
  end
end
