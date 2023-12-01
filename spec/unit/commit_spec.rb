# frozen_string_literal: true

require 'spec_helper'

describe Commit do
  let(:commit) { described_class.new(Fixtures.commit['commits'].first) }

  it 'commit.id should return id' do
    expect(commit.id).to eq('f2534cd63426e12f4668e55fead612cd53e632e4')
  end

  it 'commit.message should return message' do
    expect(commit.message).to eq('1212121221212212')
  end

  it 'commit.url should return url' do
    expect(commit.url).to eq('https://github.com/flaminestone/test/commit/f2534cd63426e12f4668e55fead612cd53e632e4')
  end

  it 'commit.author should return author object' do
    expect(commit.author).to be_a(Author)
  end
end
