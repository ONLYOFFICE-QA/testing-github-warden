# frozen_string_literal: true

require 'spec_helper'

describe AllowedBranchesParser do
  let(:parser) { described_class.new }
  let(:hash_data) { StaticData.commit }

  it 'branch should be allowed if repo and branch found' do
    hash_data['ref'] = 'refs/heads/test_branch_first'
    commit_req = GithubResponceObjects.new(hash_data)
    expect(incorrect_parser).to be_allowed_branch(commit_req)
  end

  it 'branch should not be allowed if no branch found' do
    hash_data['ref'] = 'foo'
    commit_req = GithubResponceObjects.new(hash_data)
    expect(parser).not_to be_allowed_branch(commit_req)
  end

  it 'branch should not be allowed if no repo found' do
    hash_data['repository']['name'] = 'foo'
    commit_req = GithubResponceObjects.new(hash_data)
    expect(parser).not_to be_allowed_branch(commit_req)
  end
end
