# frozen_string_literal: true

require 'spec_helper'

describe Executioner do
  let(:executioner) { described_class.new }

  it 'bug_is_commented? return true for commented bug' do
    expect(executioner.bug_is_commented?('79c80cbd36c832ea15e9545715ea8f56bdaa03f0', [{ 'bug_id' => '51121' }])).to eq(true)
  end

  it 'bug_is_commented? return false for non-existing bug' do
    expect(executioner.bug_is_commented?('79c80cbd36c832ea15e9545715ea8f56bdaa03f0', [{ 'bug_id' => '51121000' }])).to eq(false)
  end
end
