module HookDirection
  def find_action(object)
    result = []
    YAML.load_file('config/warden_config.yml').each do |current_pattern|
      repo_status = repository_check(object.repository.name, current_pattern)
      next unless repo_status

      branch_status = branch_check(object.branch, current_pattern)
      next unless branch_status

      object.commits.each do |commit|
        result << run_action(commit, current_pattern[:action], object.branch) if commits_check(commit.message, current_pattern)
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

  def run_action(commit, action, branch)
    bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
    case action
    when 'test_action'
      { action: 'test_action', commit: commit.message }
    when 'close test bug'
      bugzilla.update_bug(39_463,
                          status: 'RESOLVED',
                          resolution: 'FIXED')
      { action: 'close test bug', commit: commit.message }
    when 'close test bug and comment'
      bugzilla.update_bug(39_463,
                          status: 'RESOLVED',
                          resolution: 'FIXED')
      branch = "Commit pushed to #{branch}"
      message = "Message: #{commit.message}"
      author = "Author: #{commit.author.name}"
      full_comment = "#{branch}\n#{commit.url}\n#{message}\n#{author}"
      bugzilla.add_comment(39_463, full_comment)
      { action: 'close test bug and comment', commit: commit.message, comment: full_comment }
    when 'add resolved/fixed to bug and comment'
      bugzilla.update_bug(commit.message.scan(/\d+/)[0],
                          status: 'RESOLVED',
                          resolution: 'FIXED')
      branch = "Commit pushed to #{branch}"
      message = "Message: #{commit.message}"
      author = "Author: #{commit.author.name}"
      full_comment = "#{branch}\n#{commit.url}\n#{message}\n#{author}"
      bugzilla.add_comment(commit.message.scan(/\d+/)[0], full_comment)
      { action: 'add resolved/fixed to bug and comment', commit: commit.message, comment: full_comment }
    else
      { action: 'nothing' }
    end
  end
end
