# frozen_string_literal: true

require_relative 'github_objects/repository'
require_relative 'github_objects/commit'
class GithubResponceObjects
  attr_accessor :repository, :branch, :commits, :compare
  def initialize(params)
    @repository = Repository.new(params['repository'])
    @branch = params['ref'] if params['ref']
    @commits = params['commits'].map { |commit| Commit.new(commit) } if params['commits']
    @compare = params['compare'] if params['compare']
  end
end
