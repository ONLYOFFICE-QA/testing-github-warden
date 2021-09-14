# frozen_string_literal: true

# Parser for configure file `allowed_branches.yml`
class AllowedBranchesParser
  # @param path [String] path to file to parse
  def initialize(path = 'config/allowed_branches.yml')
    @data = YAML.load_file(path)
  end

  # Check if actions on this branch is allowed
  # If repository name is found in allowed_branches.yml, bug status will change
  # If repository is found in allowed_branches.yml, but branch name is not matched, bug status will not be change
  # @param object [GithubResponceObjects] object with data for allowance
  # @return [Boolean]
  def allowed_branch?(object)
    @data.each do |patterns|
      next unless patterns[:repository_name_array].include?(object.repository.name)
      next unless /#{patterns[:branch_pattern]}/.match?(object.branch)

      return true
    end
    false
  end
end
