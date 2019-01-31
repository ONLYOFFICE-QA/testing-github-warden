require 'redis'
require 'json'
require 'logger'
require 'onlyoffice_bugzilla_helper'
module ExecutionerHelper

  def add_resolved_fixed(action_data)
    @logger.info ">> Add RESOLVED/FIXED to bug #{action_data['bug_ud']}"
    responce = @bugzilla.update_bug(action_data['bug_id'],
                                    status: 'RESOLVED',
                                    resolution: 'FIXED')
    @logger.info "Bugzilla responce #{responce.body}"
  end

  def add_comment(action_data)
    logger.info ">> Add comment to bug #{action_data['bug_id']}"
    result = @bugzilla.add_comment(action_data['bug_id'], action_data['comment'])
    logger.info "Bugzilla responce #{result.body}"
    @logger.info 'add_comment'
  end

  def diagnostic()
    bugzilla_key_exist = !ENV['BUGZILLA_API_KEY'].empty?
    bugzilla_key_is_visible = !OnlyofficeBugzillaHelper::BugzillaHelper.read_token.empty?
    redis_is_work = false
    begin
      @redis.lpush "test_list", 'test_note'
      redis_is_work = 'test_note' == @redis.lpop("test_list")
    rescue
      redis_is_work = false
    end
    all_right = bugzilla_key_exist && bugzilla_key_is_visible && redis_is_work
    @logger.info "bugzilla key exist: #{bugzilla_key_exist}"
    @logger.info "bugzilla key is visible: #{bugzilla_key_is_visible}"
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