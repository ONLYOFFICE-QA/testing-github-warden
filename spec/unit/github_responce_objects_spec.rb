# frozen_string_literal: true

require 'spec_helper'

describe GithubResponceObjects do
  let(:github_object) { described_class.new(Fixtures.commit) }

  it 'github_object.repository should return repository object' do
    expect(github_object.repository).to be_a(Repository)
  end

  describe 'branch' do
    it 'github_object.branch should return branch name' do
      expect(github_object.branch).to eq('refs/heads/develop')
    end

    it 'github_object.branch should return nil if branch not specified' do
      commit = Fixtures.commit
      commit['ref'] = nil
      github_object = described_class.new(commit)
      expect(github_object.branch).to be_nil
    end
  end

  describe 'commits' do
    it 'github_object.commits should be an array' do
      expect(github_object.commits).to be_a(Array)
    end

    it 'github_object.commits elements should be Commit' do
      expect(github_object.commits[0]).to be_a(Commit)
    end

    it 'github_object.commits should be empty if no commits' do
      commit = Fixtures.commit
      commit['commits'] = nil
      github_object = described_class.new(commit)
      expect(github_object.commits).to be_nil
    end
  end
end
