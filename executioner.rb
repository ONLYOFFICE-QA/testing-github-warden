# Is a service for commenting and closing bugs from bugzilla
require 'redis'
@redis = Redis.new(path: "tmp/redis/redis.sock")

loop do
  p 'loop'
  p @redis.lpop("github_warden_action")
  p @redis.lrange('github_warden_action', 0, -1)
  sleep 5
end