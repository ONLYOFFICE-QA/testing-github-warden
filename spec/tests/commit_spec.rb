require_relative '../test_management'

http = nil
describe 'Commit smoke' do
  before :each do
    http = Http.new
  end

  describe 'One commit smoke' do
    it 'one commit | do nothing' do
      responce = http.post_request(params: StaticData.commit)
      expect(responce.body).to be_empty
    end

    it 'one commit | only repository match' do
      commit_req = StaticData.commit
      commit_req['repository']['name'] = 'test_repo'
      responce = http.post_request(params: commit_req)
      expect(responce.body).to be_empty
    end

    it 'one commit | test_action' do
      commit_req = StaticData.commit
      commit_req['repository']['name'] = 'test_repo'
      commit_req['commits'][0]['message'] = 'test_commit_message'
      responce = http.post_request(params: commit_req)
      expect(responce.body[commit_req['commits'][0]['id']].first['action']).to eq('test_action')
    end
  end

  describe 'Actions' do

    it 'check add_comment action' do
      commit_req = StaticData.commit
      commit_req['ref'] = 'refs/heads/develop'
      commit_req['commits'][0]['message'] = 'bug 39463'
      commit_req['html_url'] = "https://githubb-fake-rebo/#{Faker::Dota.hero}"
      commit_req['commits'][0]['author']['name'] = Faker::StarWars.character
      responce = http.post_request(params: commit_req)
      branch = "Commit pushed to #{commit_req['ref']}"
      commit = commit_req['commits'][0]['url']
      message = "Message: #{commit_req['commits'][0]['message']}"
      author = "Author: #{commit_req['commits'][0]['author']['name']}"
      responce_commit = responce.body[commit_req['commits'][0]['id']]
      expect(responce_commit.first['commit_message']).to eq(commit_req['commits'][0]['message'])
      expect(responce_commit.first['action']).to eq('add_comment')
      expect(responce_commit.first['comment']).to eq("#{branch}\n#{commit}\n#{message}\n#{author}")
    end

    it 'check add_resolved_fixed and add_comment actions' do
      commit_req = StaticData.commit
      commit_req['ref'] = 'refs/heads/test_branch_first'
      commit_req['html_url'] = "https://githubb-fake-rebo/test"
      commit_req['commits'][0]['message'] = 'Fix bug 39463'
      commit_req['commits'][0]['author']['name'] = Faker::StarWars.character
      responce = http.post_request(params: commit_req)
      expect(responce.body[commit_req['commits'][0]['id']].size).to eq(2)
      expect(responce.body[commit_req['commits'][0]['id']][0]['action']).to eq('add_resolved_fixed')
      expect(responce.body[commit_req['commits'][0]['id']][1]['action']).to eq('add_comment')
    end
  end

end
