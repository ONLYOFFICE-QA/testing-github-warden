# frozen_string_literal: true

require 'spec_helper'

describe Executioner do
  let(:executioner) { described_class.new }
  let(:correct_bug_data) { [{ 'bug_id' => '51121' }] }
  let(:correct_commit_hash) { '79c80cbd36c832ea15e9545715ea8f56bdaa03f0' }
  let(:incorrect_bug_data) { [{ 'bug_id' => '51121000' }] }

  describe 'bug_is_commented?' do
    it 'bug_is_commented? return true for commented bug' do
      expect(executioner.bug_is_commented?(correct_commit_hash, correct_bug_data)).to eq(true)
    end

    it 'bug_is_commented? return false for non-existing bug' do
      expect(executioner.bug_is_commented?(correct_commit_hash, incorrect_bug_data)).to eq(false)
    end
  end

  describe 'bug_should_be_handled?' do
    it 'bug_should_be_handled? return true for existing bug with not existing hash' do
      expect(executioner.bug_should_be_handled?(correct_bug_data, 'fake-hash')).to eq(true)
    end

    it 'bug_should_be_handled? return false for existing bug with correct fix hash' do
      expect(executioner.bug_should_be_handled?(correct_bug_data, correct_commit_hash)).to eq(false)
    end

    it 'bug_should_be_handled return false for non-existing bug' do
      expect(executioner.bug_should_be_handled?(incorrect_bug_data, correct_commit_hash)).to eq(false)
    end
  end
end
