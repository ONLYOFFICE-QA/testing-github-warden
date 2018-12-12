module HookDirection
  def find_action(object)
    result = []
    @bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
    YAML.load_file('config/warden_config.yml').each do |current_pattern|
      object.commits.each do |commit|
        result << run_action(commit, current_pattern[:action], object.branch) if commits_check(commit.message, current_pattern)
      end
    end
    result
  end

  def commits_check(name, patterns)
    pattern_match = Regexp.new(patterns[:commit_message_pattern]).match?(name)
    antipattern_match = false
    if patterns[:commit_message_antipattern]
      antipattern_match = Regexp.new(patterns[:commit_message_antipattern]).match?(name)
    end
    pattern_match && !antipattern_match
  end

  def run_action(commit, action, branch)
    full_comment = create_full_comment(commit, branch)
    case action
    when 'test_action'
      test_action(commit)
    when 'add_comment'
      add_comment(commit, full_comment)
    when 'add_resolved_fixed_and_comment'
      add_resolved_fixed_and_comment(commit, full_comment)
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

  def add_comment(commit, full_comment)
    bug_id = commit.message.scan(/\d+/)[0]
    Thread.new do
      @bugzilla.add_comment(bug_id, full_comment)
    end
    { action: 'add_comment', commit: commit.message, comment: full_comment }
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

  def add_resolved_fixed_and_comment(commit, full_comment)
    bug_id = commit.message.scan(/\d+/)[0]
    change_status = bug_new_or_reopen(bug_id)
    resolved_fixed_bug(bug_id) if change_status
    add_comment(commit, full_comment)
    { action: 'add_resolved_fixed_and_comment', commit: commit.message, comment: full_comment, status_change: change_status }
  end

  def bug_new_or_reopen(bug_id)
    bug_status = @bugzilla.bug_data(bug_id)['status']
    %w[NEW REOPEN].include?(bug_status)
  end
end
