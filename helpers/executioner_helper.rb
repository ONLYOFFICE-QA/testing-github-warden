# frozen_string_literal: true

require 'bundler/setup'
require 'redis'
require 'json'
require 'logger'
require 'onlyoffice_bugzilla_helper'
module ExecutionerHelper
  def add_resolved_fixed(action_data)
    @logger.info ">> Add RESOLVED/FIXED to bug #{action_data['bug_id']}"
    return unless change_status?(action_data)

    responce = {}
    5.times do |i|
      @logger.info ">> Add(#{i + 1}) RESOLVED/FIXED to bug #{action_data['bug_id']}"
      responce = @bugzilla.update_bug(action_data['bug_id'],
                                      status: 'RESOLVED',
                                      resolution: 'FIXED')
      @logger.info "Bugzilla responce #{responce.body}"

      break unless responce['error']

      @logger.info "Error found #{responce['error']}. Retrying..."
      sleep 15
    end
    responce
  end

  def add_comment(action_data)
    responce = {}
    5.times do |i|
      @logger.info ">> Add(#{i + 1}) comment to bug #{action_data['bug_id']}"
      responce = @bugzilla.add_comment(action_data['bug_id'], action_data['comment'])
      @logger.info "Bugzilla responce #{responce.body}"
      break unless responce['error']

      @logger.info "Error found #{responce['error']}. Retrying..."
      sleep 15
    end
    responce
  end

  def change_status?(action_data)
    5.times do |i|
      @logger.info "Getting(#{i + 1}) data of bug #{action_data['bug_id']}"
      responce = @bugzilla.bug_data(action_data['bug_id'])
      @logger.info "Bugzilla responce #{responce}"
      if responce['error']
        @logger.info "Error found #{responce['error']}. Retrying..."
        sleep 15
      else
        status_change = %w[NEW REOPENED ASSIGNED].include?(responce['status'])
        @logger.info "Bugzilla responce for bug : bug #{action_data['bug_id']} status #{responce['status']}. Status will #{'NOT ' unless status_change}change"
        break status_change
      end
    end
  end

  def bug_is_commented?(commit_hash, action_data)
    return true if action_data.select { |action| action['bug_id'] }.empty?

    bug_id = action_data.select { |action| action['bug_id'] }.first['bug_id']
    comments = []
    5.times do |i|
      @logger.info ">> Gettings(#{i + 1}) comments of bug #{bug_id}"
      begin
        comments = @bugzilla.comments(bug_id)
      rescue StandardError
        @logger.warn "Bugzilla error!!"
      end
      @logger.info "Bugzilla responce #{comments}"

      break if comments.is_a?(Array)

      @logger.info "Error found #{comments}. Retrying..."
      sleep 15
    end
    result = comments.select do |comment|
      comment['text'].include? commit_hash
    end
    !result.empty?
  end

  def diagnostic
    bugzilla_key_exist = !ENV['BUGZILLA_API_KEY'].nil? && ENV['BUGZILLA_API_KEY'] != ''
    redis_is_work = false
    begin
      @redis.lpush "test_list", 'test_note'
      redis_is_work = 'test_note' == @redis.lpop("test_list")
    rescue StandardError
      redis_is_work = false
    end
    all_right = bugzilla_key_exist && redis_is_work
    @logger.info "bugzilla key exist: #{bugzilla_key_exist}"
    @logger.info "redis is working: #{redis_is_work}"
    raise('Diagnostic error! See logs') unless all_right

    puts "████████████████████████████████
█─███─█────█────█────██───█─██─█
█─███─█─██─█─██─█─██──█─███──█─█
█─█─█─█────█────█─██──█───█─█──█
█─────█─██─█─█─██─██──█─███─██─█
██─█─██─██─█─█─██────██───█─██─█
████████████████████████████████"
  end
end
