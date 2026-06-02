# frozen_string_literal: true

require_relative 'github_objects/repository'
require_relative 'github_objects/commit'
# Class for working with GitHubResponce objects
class GithubResponceObjects
  # @return [Regexp] regexp for extracting version from branch name
  VERSION_REGEXP = /v?(\d+\.\d+[\.\d]*)/
  # @return [String] default version for branches without a version number
  DEFAULT_VERSION = '99.99'
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

  # Extract version from branch name
  # Strips trailing .0 patch to match Bugzilla version format
  # @example "refs/heads/hotfix/v9.4.0" => "9.4"
  # @example "refs/heads/hotfix/v9.4.1" => "9.4.1"
  # @example "refs/heads/hotfix/v10.0.0" => "10.0"
  # @example "refs/heads/develop" => "99.99"
  # @return [String] version string or DEFAULT_VERSION if not found
  def branch_version
    return DEFAULT_VERSION unless @branch

    match = @branch.match(VERSION_REGEXP)
    return DEFAULT_VERSION unless match

    match[1].sub(/\.0$/, '')
  end
end
