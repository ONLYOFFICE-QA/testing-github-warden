module HookDirection
  def find_action(object)
    result = []
    YAML.load_file('config/warden_config.yml').each do |current_pattern|
      repo_status = repository_check(object.repository.name, current_pattern)
      next unless repo_status

      branch_status = branch_check(object.branch, current_pattern)
      next unless branch_status

      object.commits.each do |commit|
        result << run_action(commit, current_pattern[:action]) if commits_check(commit.message, current_pattern)
      end
    end
    result
  end

  def repository_check(name, pattern)
    Regexp.new(pattern[:repository_name_pattern]).match?(name)
  end

  def branch_check(name, pattern)
    Regexp.new(pattern[:branch_name_pattern]).match?(name)
  end

  def commits_check(name, patterns)
    Regexp.new(patterns[:commit_message_pattern]).match?(name)
  end

  def run_action(commit, action)
    case action
    when 'test_action'
      { action: 'test_action', commit: commit.message }
    else
      { action: 'nothing' }
    end
  end
end
