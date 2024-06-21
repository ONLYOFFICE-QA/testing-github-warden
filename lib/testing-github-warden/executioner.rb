# frozen_string_literal: true

require 'bundler/setup'
require 'redis'
require 'json'
require 'logger'
require 'onlyoffice_bugzilla_helper'
require_relative 'executioner/executioner_helper'
require_relative '../../helpers/version_helper'

# Class for execute closing bugs received from redis
class Executioner
  include ExecutionerHelper

  def initialize
    @logger = Logger.new($stdout)
    @redis = Redis.new(path: 'tmp/redis/redis.sock')
    @bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
    @logger.info 'Executioner initialized'
    @version = VersionHelper.load_version
  end

  # Perform diagnostic of Executioner
  # @return [void]
  def diagnostic
    bugzilla_key_exist = check_bugzilla_key?
    working_redis = check_redis?
    all_services_ok = bugzilla_key_exist && working_redis
    @logger.info "bugzilla key exist: #{bugzilla_key_exist}"
    @logger.info "redis is working: #{working_redis}"
    @logger.info "Version: #{@version}"
    raise('Diagnostic error! See logs') unless all_services_ok

    puts "████████████████████████████████
█─███─█────█────█────██───█─██─█
█─███─█─██─█─██─█─██──█─███──█─█
█─█─█─█────█────█─██──█───█─█──█
█─────█─██─█─█─██─██──█─███─██─█
██─█─██─██─█─█─██────██───█─██─█
████████████████████████████████"
  end

  # Main loop of process
  # This method do not stop by itself
  # @return [void]
  def main_loop
    loop do
      data = @redis.lpop('github_warden_action')
      begin
        data = JSON.parse(data) if data
        if data.is_a?(Hash) && !data.empty?
          @logger.info "Current data #{data}"
          data.each do |hash, action_data|
            next unless bug_should_be_handled?(action_data, hash)

            action_data.each do |action|
              case action['action']
              when 'add_resolved_fixed'
                add_resolved_fixed(action)
              when 'add_comment'
                add_comment(action)
              when 'nothing'
                @logger.info 'Do nothing'
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
      rescue StandardError => e
        @logger.warn("Error `#{e}` happened while handling `#{data}`. Returning data to redis")
        @redis.lpush 'github_warden_action', data.to_json
      end
    end
  end

  private

  # Check if bugzilla key correctly exists
  # @return [Boolean] result of check
  def check_bugzilla_key?
    return false unless ENV['BUGZILLA_API_KEY']
    return false if ENV['BUGZILLA_API_KEY'].empty?

    true
  end

  # Check if redis correctly setup
  # @return [Boolean] result of check
  def check_redis?
    queue = 'test_list'
    message = 'test_note'
    @redis.lpush(queue, message)
    @redis.lpop(queue) == message
  rescue StandardError => e
    @logger.info("Redis is not working because of: `#{e}`")
    false
  end
end
