module HookDirection
  def find_action(object)
    # result has structure: {commit_id: [{commit_message: string, bug_id: number, }], commit_id: ...}
    result = {}
    YAML.load_file('config/warden_config.yml').each do |current_pattern|
      object.commits.reverse.each do |commit|
        next unless commit.message.downcase =~ /#{current_pattern[:commit_message_pattern]}/
        next unless allowed_branch(object)

        bug_id = commit.message.downcase[/bug.#?(\d+)/].to_s[/\d+/]
        result[commit.id] = [] unless result[commit.id]
        result[commit.id] << { commit_message: commit.message,
                               comment: create_full_comment(commit, object.branch),
                               bug_id: bug_id,
                               action: current_pattern[:action] }
      end
    end
    result
  end

  def create_full_comment(commit, branch)
    branch = "Commit pushed to #{branch}"
    message = "Message: #{commit.message}"
    author = "Author: #{commit.author.name}"
    "#{branch}\n#{commit.url}\n#{message}\n#{author}"
  end

  # method for adding access to change bug status
  # If repository name is not found in allowed_branches.yml, bug status will change
  # If repository is found in allowed_branches.yml, but branch name is not matched, bug status will not be change
  def allowed_branch(object)
    allow = false
    YAML.load_file('config/allowed_branches.yml').each do |patterns|
      next unless patterns[:repository_name_array].include? object.repository.name
      next unless object.branch =~ /#{patterns[:branch_pattern]}/

      allow = true
      break
    end
    allow
  end
  #
  #
  #
  # def commits_check(name, patterns)
  #   name =~ /#{patterns[:commit_message_pattern]}/
  # end
  #
  #
  # def run_action(commit, action, branch, bug_id)
  #   full_comment = create_full_comment(commit, branch)
  #   case action
  #   when 'test_action'
  #     { test_action_execut: true }
  #   when 'add_comment'
  #     add_comment(bug_id, full_comment)
  #   when 'add_resolved_fixed'
  #     add_resolved_fixed(bug_id)
  #   end
  # end
  #
  # def resolved_fixed_bug(bug_id)
  #   Thread.new do
  #     logger.info ">> Start to add RESOLVED/FIXED to bug #{bug_id}"
  #     result = OnlyofficeBugzillaHelper::BugzillaHelper.new.update_bug(bug_id,
  #                                                                      status: 'RESOLVED',
  #                                                                      resolution: 'FIXED')
  #     logger.info "Bugzilla responce #{result.body}"
  #     logger.info "<< End to add RESOLVED/FIXED to bug #{bug_id}"
  #   end
  # end
  #
  # def add_comment(bug_id, full_comment)
  #   Thread.new do
  #     logger.info ">> Start to add comment to bug #{bug_id}"
  #     result = @bugzilla.add_comment(bug_id, full_comment)
  #     logger.info "Bugzilla responce #{result.body}"
  #     logger.info "<< End to add comment to bug #{bug_id}"
  #   end
  #   { comment: full_comment}
  # end
  #
  # def create_full_comment(commit, branch)
  #   branch = "Commit pushed to #{branch}"
  #   message = "Message: #{commit.message}"
  #   author = "Author: #{commit.author.name}"
  #   "#{branch}\n#{commit.url}\n#{message}\n#{author}"
  # end
  #
  # def add_resolved_fixed(bug_id)
  #   change_status = bug_new_or_reopen(bug_id)
  #   resolved_fixed_bug(bug_id) if change_status
  #   { status_change: change_status }
  # end
  #
  # def bug_new_or_reopen(bug_id)
  #   bug_status = @bugzilla.bug_data(bug_id)['status']
  #   logger.info "Bugzilla responce for bug : bug #{bug_id} status #{bug_status}"
  #   %w[NEW REOPENED ASSIGNED].include?(bug_status)
  # end
end
