# frozen_string_literal: true

require 'spec_helper'

describe AllowedBranchesParser do
  let(:parser) { described_class.new }
  let(:hash_data) { Fixtures.commit }

  it 'branch should be allowed if repo and branch found' do
    hash_data['ref'] = 'refs/heads/test_branch_first'
    commit_req = GithubResponceObjects.new(hash_data)
    expect(parser).to be_allowed_branch(commit_req)
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

  describe 'product repositories' do
    before { hash_data['repository']['name'] = 'sdkjs' }

    %w[develop release/v10.0.0 hotfix/v9.4.5 hotfix/v9.4].each do |branch|
      it "allows #{branch}" do
        hash_data['ref'] = "refs/heads/#{branch}"
        expect(parser).to be_allowed_branch(GithubResponceObjects.new(hash_data))
      end
    end

    %w[feat/hotfix-10-0-1 feature/release-notes fix/develop-crash hotfix/v9.4.5-test
       release/10.0.0 hotfix master develop2].each do |branch|
      it "does not allow #{branch}" do
        hash_data['ref'] = "refs/heads/#{branch}"
        expect(parser).not_to be_allowed_branch(GithubResponceObjects.new(hash_data))
      end
    end
  end
end
