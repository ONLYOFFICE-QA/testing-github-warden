# frozen_string_literal: true

require 'spec_helper'

describe Executioner do
  let(:executioner) { described_class.new }

  describe 'bug_is_commented?' do
    it 'bug_is_commented? return true for commented bug' do
      expect(executioner.bug_is_commented?('79c80cbd36c832ea15e9545715ea8f56bdaa03f0', [{ 'bug_id' => '51121' }])).to eq(true)
    end

    it 'bug_is_commented? return false for non-existing bug' do
      expect(executioner.bug_is_commented?('79c80cbd36c832ea15e9545715ea8f56bdaa03f0', [{ 'bug_id' => '51121000' }])).to eq(false)
    end
  end

  describe 'bug_should_be_handled?' do
    it 'bug_should_be_handled? return true for existing bug with not existing hash' do
      expect(executioner.bug_should_be_handled?([{ 'bug_id' => '51121' }], 'fake-hash')).to eq(true)
    end

    it 'bug_should_be_handled? return false for existing bug with correct fix hash' do
      expect(executioner.bug_should_be_handled?([{ 'bug_id' => '51121' }], '79c80cbd36c832ea15e9545715ea8f56bdaa03f0')).to eq(false)
    end

    it 'bug_should_be_handled return false for non-existing bug' do
      expect(executioner.bug_should_be_handled?([{ 'bug_id' => '51121000' }], '79c80cbd36c832ea15e9545715ea8f56bdaa03f0')).to eq(false)
    end
  end
end
