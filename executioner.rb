# Is a service for commenting and closing bugs from bugzilla
require_relative 'helpers/executioner_helper'
include ExecutionerHelper


@redis = Redis.new(path: "tmp/redis/redis.sock")
@bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
@logger = Logger.new(STDOUT)
@logger.info 'Executioner started'

diagnostic

loop do
  data = @redis.lpop("github_warden_action")
  data = JSON.parse(data) if data
  if data.is_a?(Hash)
    data.values do |action_data|
      case action_data['action']
      when 'add_resolved_fixed'
        add_resolved_fixed(action_data)
      when 'add_comment'
        add_comment(action_data)
      end
    end
  end
  sleep 60
  @logger.info @redis.lrange('github_warden_action', 0, -1)
end
