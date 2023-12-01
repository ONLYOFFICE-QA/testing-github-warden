# frozen_string_literal: true

# Helper methods for Executioner class
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
        log_entry = "Bugzilla responce for bug : bug #{action_data['bug_id']} " \
                    "status #{responce['status']}. " \
                    "Status will #{'NOT ' unless status_change}change"
        @logger.info(log_entry)
        break status_change
      end
    end
  end

  # Check if bug already was correctly commented
  # @param commit_hash [String] commit hash string
  # @param action_data [Hash] Github hook hash
  # @return [Boolean]
  def bug_is_commented?(commit_hash, action_data)
    bug_id = action_data.find { |action| action['bug_id'] }['bug_id']
    comments = []
    5.times do |i|
      @logger.info ">> Gettings(#{i + 1}) comments of bug #{bug_id}"
      begin
        comments = @bugzilla.comments(bug_id)
      rescue StandardError
        @logger.warn 'Bugzilla error!!'
      end
      @logger.info "Bugzilla responce #{comments}"

      break if comments.is_a?(Array)

      @logger.info "Error found #{comments}. Retrying..."
      sleep 15
    end
    result = comments.select do |comment|
      comment['text'].include?(commit_hash)
    end
    commented = !result.empty?
    @logger.info("Is bug #{bug_id} already has comment with commit_hash #{commit_hash}: #{commented}")
    commented
  end

  # Check if any action with bug should be done at all
  # @param action_data [Array<Hash>] Github hook hash
  # @param commit_hash [String] commit hash string
  # @return [Boolean]
  def bug_should_be_handled?(action_data, commit_hash)
    return false unless hook_data_include_bug_number?(action_data)
    return false unless bug_exists?(action_data)
    return false if bug_is_commented?(commit_hash, action_data)

    true
  end

  # Check if bug exists at all
  # @param action_data [Array<Hash>] Github hook hash
  # @return [True, False]
  def bug_exists?(action_data)
    bug_id = action_data.find { |action| action['bug_id'] }['bug_id']

    exists = @bugzilla.bug_exists?(bug_id)
    @logger.info("Bug for data: #{action_data} do not exists. Someone probably make a typo.") unless exists
    exists
  end

  # Check if hook data contains bug id
  # @param action_data [Array<Hash>] Github hook hash
  # @return [Boolean]
  def hook_data_include_bug_number?(action_data)
    include = action_data.any? { |action| action['bug_id'] }

    @logger.info("Github hook data: #{action_data} do not contains any bug_id. Skipping") unless include

    include
  end
end
