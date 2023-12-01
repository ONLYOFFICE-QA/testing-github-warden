# frozen_string_literal: true

require 'spec_helper'

describe Commit, '#bug_id' do
  it 'Correct bug_id if message is correct' do
    commit = described_class.new('message' => 'Fix bug #51121',
                                 'author' => StaticData.commit['commits'].first['author'])
    expect(commit.bug_id).to eq('51121')
  end

  it 'bug_id nil if message is not correct' do
    commit = described_class.new('message' => 'Fix big 51121',
                                 'author' => StaticData.commit['commits'].first['author'])
    expect(commit.bug_id).to be_nil
  end
end
