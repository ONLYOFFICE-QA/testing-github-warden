# frozen_string_literal: true

module HookDirection
  def find_action(object)
    # result has structure: {commit_id: [{commit_message: string, bug_id: number, }], commit_id: ...}
    result = {}
    YAML.load_file('config/warden_config.yml').each do |current_pattern|
      object.commits.reverse_each do |commit|
        next unless /#{current_pattern[:commit_message_pattern]}/.match?(commit.message.downcase)
        next unless @allowed_branch_parser.allowed_branch?(object)

        bug_id = commit.message.downcase[/bug\s+#?(\d+)/].to_s[/\d+/]
        result[commit.id] = [] unless result[commit.id]
        result[commit.id] << { commit_message: commit.message,
                               comment: create_full_comment(commit, object.branch),
                               bug_id:,
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
end
