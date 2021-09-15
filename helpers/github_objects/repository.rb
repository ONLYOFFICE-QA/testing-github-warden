# frozen_string_literal: true

# Class for storing repository data
class Repository
  # @return [String] name of repo, like `test`
  attr_reader :name
  # @return [String] full name of repo with user/organisation, like `onlyoffice-qa/test`
  attr_reader :full_name

  # @param params [Hash] data to parse
  def initialize(params)
    @name = params['name']
    @full_name = params['full_name']
  end
end
