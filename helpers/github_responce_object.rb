# frozen_string_literal: true

require_relative 'github_objects/repository'
require_relative 'github_objects/commit'
# Class for working with GitHubResponce objects
class GithubResponceObjects
  # @return [Repository] repository data
  attr_reader :repository
  # @return [String] branch name
  attr_reader :branch
  # @return [Array<Commit>] array of commits
  attr_reader :commits

  # @param params [Hash] data from github responce
  def initialize(params)
    @repository = Repository.new(params['repository'])
    @branch = params['ref'] if params['ref']
    @commits = params['commits'].map { |commit| Commit.new(commit) } if params['commits']
  end
end
