# frozen_string_literal: true

require 'spec_helper'

describe GithubResponceObjects do
  let(:github_object) { described_class.new(Fixtures.commit) }

  it 'github_object.repository should return repository object' do
    expect(github_object.repository).to be_a(Repository)
  end

  it 'github_object.branch should return branch name' do
    expect(github_object.branch).to eq('refs/heads/develop')
  end

  it 'github_object.commits should be an array' do
    expect(github_object.commits).to be_a(Array)
  end

  it 'github_object.commits elements should be Commit' do
    expect(github_object.commits[0]).to be_a(Commit)
  end
end
