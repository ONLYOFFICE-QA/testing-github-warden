# Is a service for commenting and closing bugs from bugzilla
require_relative 'helpers/executioner_helper'
include ExecutionerHelper

@logger = Logger.new(STDOUT)
@redis = Redis.new(path: "tmp/redis/redis.sock")
@bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
@logger.info 'Executioner started'
diagnostic

loop do
  data = @redis.lpop("github_warden_action")
  begin
    data = JSON.parse(data) if data
    if data.is_a?(Hash) && !data.empty?
      @logger.info "Current data #{data}"
      data.each do |hash, action_data|
        next if bug_is_commented?(hash, action_data)
        action_data.each do |action|
          case action['action']
          when 'add_resolved_fixed'
            add_resolved_fixed(action)
          when 'add_comment'
            add_comment(action)
          when 'nothing'
            @logger.info "Do nothing"
          else
            @logger.warn "Attention! Unknown action #{action}"
          end
        end
      end
    else
      queue = @redis.lrange('github_warden_action', 0, -1)
      @logger.info "Queue: #{queue}"
      if queue.empty?
        @logger.info 'Sleep 60'
        sleep 60
      end
    end
  rescue
    @redis.lpush "github_warden_action", data.to_json
  end
end
