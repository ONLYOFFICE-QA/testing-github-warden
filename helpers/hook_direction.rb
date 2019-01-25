module HookDirection
  def find_action(object)
    result = {}
    @bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
    YAML.load_file('config/warden_config.yml').each do |current_pattern|
      object.commits.each do |commit|
        next unless commit.message.downcase =~ /#{current_pattern[:commit_message_pattern]}/

        bug_id = get_bug_id(commit)
        result[commit.id] = { commit_message: commit.message, bug_id: bug_id } unless result[commit.id]
        result[commit.id][current_pattern[:action]] = run_action(commit, current_pattern[:action], object.branch, bug_id)
      end
    end
    result
  end

  def commits_check(name, patterns)
    name =~ /#{patterns[:commit_message_pattern]}/
  end

  def get_bug_id(commit)
    commit.message[/[B|b]ug.#?(\d+)/].to_s[/\d+/]
  end

  def run_action(commit, action, branch, bug_id)
    full_comment = create_full_comment(commit, branch)
    case action
    when 'test_action'
      { test_action_execut: true }
    when 'add_comment'
      add_comment(bug_id, full_comment)
    when 'add_resolved_fixed'
      add_resolved_fixed(bug_id)
    end
  end

  def resolved_fixed_bug(bug_id)
    Thread.new do
      logger.info ">> Start to add RESOLVED/FIXED to bug #{bug_id}"
      result = OnlyofficeBugzillaHelper::BugzillaHelper.new.update_bug(bug_id,
                                                                       status: 'RESOLVED',
                                                                       resolution: 'FIXED')
      logger.info "Bugzilla responce #{result.body}"
      logger.info "<< End to add RESOLVED/FIXED to bug #{bug_id}"
    end
  end

  def add_comment(bug_id, full_comment)
    Thread.new do
      logger.info ">> Start to add comment to bug #{bug_id}"
      result = @bugzilla.add_comment(bug_id, full_comment)
      logger.info "Bugzilla responce #{result.body}"
      logger.info "<< End to add comment to bug #{bug_id}"
    end
    { comment: full_comment}
  end

  def create_full_comment(commit, branch)
    branch = "Commit pushed to #{branch}"
    message = "Message: #{commit.message}"
    author = "Author: #{commit.author.name}"
    "#{branch}\n#{commit.url}\n#{message}\n#{author}"
  end

  def add_resolved_fixed(bug_id)
    change_status = bug_new_or_reopen(bug_id)
    resolved_fixed_bug(bug_id) if change_status
    { status_change: change_status }
  end

  def bug_new_or_reopen(bug_id)
    bug_status = @bugzilla.bug_data(bug_id)['status']
    logger.info "Bugzilla responce for bug : bug #{bug_id} status #{bug_status}"
    %w[NEW REOPENED ASSIGNED].include?(bug_status)
  end
end
