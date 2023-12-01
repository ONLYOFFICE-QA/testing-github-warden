# frozen_string_literal: true

require 'spec_helper'

http = nil
describe 'Allowed branch smoke' do
  before do
    http = Http.new
  end

  describe 'Allowed branch' do
    it 'check status is changed if repo name is not found' do
      commit_req = Fixtures.commit
      commit_req['ref'] = 'refs/heads/branch_name'
      commit_req['commits'][0]['message'] = 'Fix bug 39463'
      commit_req['repository']['name'] = Faker::Movies::StarWars.planet
      commit_req['commits'][0]['author']['name'] = Faker::Movies::StarWars.character
      responce = http.post_request(params: commit_req)
      expect(responce.body).to be_empty
    end

    it 'check status is not changed if repo name is found' do
      commit_req = Fixtures.commit
      commit_req['ref'] = 'refs/heads/branch_name'
      commit_req['commits'][0]['message'] = 'Fix bug 39463'
      commit_req['repository']['name'] = Faker::Movies::StarWars.planet
      commit_req['commits'][0]['author']['name'] = Faker::Movies::StarWars.character
      responce = http.post_request(params: commit_req)
      expect(responce.body).to be_empty
    end

    it 'check status is changed if branch name is found, but repo name is not found' do
      commit_req = Fixtures.commit
      commit_req['ref'] = 'refs/heads/test_branch_first'
      commit_req['commits'][0]['message'] = 'Fix bug 39463'
      commit_req['repository']['name'] = Faker::Movies::StarWars.planet
      commit_req['commits'][0]['author']['name'] = Faker::Movies::StarWars.character
      responce = http.post_request(params: commit_req)
      expect(responce.body).to be_empty
    end

    it 'check status is changed if repo name and branch name is found' do
      commit_req = Fixtures.commit
      commit_req['ref'] = 'refs/heads/test_branch_first'
      commit_req['commits'][0]['message'] = 'Fix bug 39463'
      commit_req['repository']['name'] = 'test'
      commit_req['commits'][0]['author']['name'] = Faker::Movies::StarWars.character
      responce = http.post_request(params: commit_req)
      expect(responce.body[commit_req['commits'][0]['id']].size).to eq(2)
      expect(responce.body[commit_req['commits'][0]['id']][0]['action']).to eq('add_resolved_fixed')
      expect(responce.body[commit_req['commits'][0]['id']][1]['action']).to eq('add_comment')
    end
  end

  it 'only repo name matched' do
    commit_req = Fixtures.repo_match_commit
    commit_req['repository']['name'] = 'test'
    commit_req['commits'][0]['message'] = 'Fix bug 39463'
    commit_req['commits'][0]['author']['name'] = Faker::Movies::StarWars.character
    responce = http.post_request(params: commit_req)
    expect(responce.body).to be_empty
  end
end
