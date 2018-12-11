module HookDirection
  def find_action(object)
    result = []
    @bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
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
    full_comment = create_full_comment(commit, branch)
    case action
    when 'test_action'
      test_action(commit)
    when 'close_test_bug'
      close_test_bug(commit)
    when 'close_test_bug_and_comment'
      close_test_bug_and_comment(commit, full_comment)
    when 'add_resolved_fixed_to_bug_and_comment'
      add_resolved_fixed_to_bug_and_comment(commit, full_comment)
    when 'only_comment_if_not_new_or_reopen'
      only_comment_if_not_new_or_reopen(commit, full_comment)
    else
      { action: 'nothing' }
    end
  end

  def resolved_fixed_bug(bug_id)
    Thread.new do
      OnlyofficeBugzillaHelper::BugzillaHelper.new.update_bug(bug_id,
                                                              status: 'RESOLVED',
                                                              resolution: 'FIXED')
    end
  end

  def add_comment(id, comment)
    Thread.new do
      @bugzilla.add_comment(id, comment)
    end
  end

  def create_full_comment(commit, branch)
    branch = "Commit pushed to #{branch}"
    message = "Message: #{commit.message}"
    author = "Author: #{commit.author.name}"
    "#{branch}\n#{commit.url}\n#{message}\n#{author}"
  end

  def test_action(commit)
    { action: 'test_action', commit: commit.message }
  end

  def close_test_bug(commit)
    resolved_fixed_bug(39_463)
    { action: 'close test bug', commit: commit.message }
  end

  def close_test_bug_and_comment(commit, full_comment)
    resolved_fixed_bug(39_463)
    add_comment(39_463, full_comment)
    { action: 'close test bug and comment', commit: commit.message, comment: full_comment }
  end

  def add_resolved_fixed_to_bug_and_comment(commit, full_comment)
    bug_id = commit.message.scan(/\d+/)[0]
    resolved_fixed_bug(bug_id)
    add_comment(bug_id, full_comment)
    {action: 'add_resolved_fixed_to_bug_and_comment', commit: commit.message, comment: full_comment}
  end

  def only_comment_if_not_new_or_reopen(commit, full_comment)
    bug_id = commit.message.scan(/\d+/)[0]
    bug_status = @bugzilla.bug_data(bug_id)['status']
    resolved_fixed_bug(bug_id) if %w[NEW REOPEN].include?(bug_status)
    add_comment(bug_id, full_comment)
    {action: 'only comment if not new or reopen', commit: commit.message, comment: full_comment}
  end
end
