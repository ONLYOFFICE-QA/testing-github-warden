# frozen_string_literal: true

require 'spec_helper'

http = nil
describe 'Commit smoke' do
  before do
    http = Http.new
  end

  describe 'One commit smoke' do
    it 'one commit | do nothing' do
      responce = http.post_request(params: Fixtures.commit)
      expect(responce.body).to be_empty
    end

    it 'one commit | only repository match' do
      commit_req = Fixtures.commit
      commit_req['repository']['name'] = 'test'
      commit_req['ref'] = 'refs/heads/test_branch_first'
      responce = http.post_request(params: commit_req)
      expect(responce.body).to be_empty
    end

    it 'one commit | test_action' do
      commit_req = Fixtures.commit
      commit_req['repository']['name'] = 'test'
      commit_req['ref'] = 'refs/heads/test_branch_first'
      commit_req['commits'][0]['message'] = 'test_commit_message'
      responce = http.post_request(params: commit_req)
      expect(responce.body[commit_req['commits'][0]['id']].first['action']).to eq('test_action')
    end
  end

  describe 'Actions' do
    it 'check add_comment action' do
      commit_req = Fixtures.commit
      commit_req['repository']['name'] = 'test'
      commit_req['ref'] = 'refs/heads/test_branch_first'
      commit_req['commits'][0]['message'] = 'bug 39463'
      responce = http.post_request(params: commit_req)
      commit = commit_req['commits'][0]['url']
      message = "Message: #{commit_req['commits'][0]['message']}"
      responce_commit = responce.body[commit_req['commits'][0]['id']]
      expect(responce_commit.first['commit_message']).to eq(commit_req['commits'][0]['message'])
      expect(responce_commit.first['action']).to eq('add_comment')
      comment = "Commit pushed to refs/heads/test_branch_first\n" \
                "#{commit}\n#{message}\n" \
                "Author: #{commit_req['commits'][0]['author']['name']}"
      expect(responce_commit.first['comment']).to eq(comment)
    end

    it 'check add_resolved_fixed and add_comment actions' do
      commit_req = Fixtures.commit
      commit_req['ref'] = 'refs/heads/test_branch_first'
      commit_req['html_url'] = 'https://githubb-fake-rebo/test'
      commit_req['commits'][0]['message'] = 'Fix bug 39463'
      commit_req['commits'][0]['author']['name'] = Faker::Movies::StarWars.character
      responce = http.post_request(params: commit_req)
      expect(responce.body[commit_req['commits'][0]['id']].size).to eq(2)
      expect(responce.body[commit_req['commits'][0]['id']][0]['action']).to eq('add_resolved_fixed')
      expect(responce.body[commit_req['commits'][0]['id']][1]['action']).to eq('add_comment')
    end
  end
end
