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

    it 'one commit | only repository and branch match' do
      commit_req = StaticData.commit
      commit_req['repository']['name'] = 'test_repo'
      commit_req['ref'] = 'refs/heads/test_branch'
      responce = http.post_request(params: commit_req)
      expect(responce.body).to be_empty
    end

    it 'one commit | test_action' do
      commit_req = StaticData.commit
      commit_req['repository']['name'] = 'test_repo'
      commit_req['ref'] = 'refs/heads/test_branch'
      commit_req['commits'][0]['message'] = 'test_commit_message'
      responce = http.post_request(params: commit_req)
      expect(responce.body[0]['action']).to eq('test_action')
      expect(responce.body[0]['commit']).to eq('test_commit_message')
    end

    it 'one commit | close bug' do
      bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
      bugzilla.update_bug(StaticData::BUG_ID_TEST, status: 'NEW')
      commit_req = StaticData.commit
      commit_req['repository']['name'] = 'test'
      commit_req['ref'] = 'refs/heads/develop'
      commit_req['commits'][0]['message'] = 'Fix bug 39463'
      responce = http.post_request(params: commit_req)
      result = bugzilla.bug_data(StaticData::BUG_ID_TEST)
      expect(responce.body[0]['action']).to eq('close test bug')
      expect(responce.body[0]['commit']).to eq('Fix bug 39463')
      expect(result['status']).to eq('RESOLVED')
      expect(result['resolution']).to eq('FIXED')
    end
  end

  describe 'Comment' do
    it 'comment check | add comment after closing bug' do
      bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
      bugzilla.update_bug(StaticData::BUG_ID_TEST, status: 'NEW')
      commit_req = StaticData.commit
      commit_req['repository']['name'] = 'test_close_and_comment'
      commit_req['ref'] = 'refs/heads/develop'
      commit_req['commits'][0]['message'] = 'Fix bug 39463'
      commit_req['html_url'] = "https://githubb-fake-rebo/#{Faker::Dota.hero}"
      commit_req['commits'][0]['author']['name'] = Faker::StarWars.character
      responce = http.post_request(params: commit_req)
      result_bug = bugzilla.bug_data(StaticData::BUG_ID_TEST)
      result_comments = bugzilla.comments(StaticData::BUG_ID_TEST)
      branch = "Commit pushed to #{commit_req['ref']}"
      commit = commit_req['commits'][0]['url']
      message = "Message: #{commit_req['commits'][0]['message']}"
      author = "Author: #{commit_req['commits'][0]['author']['name']}"
      expect(result_comments.last['text']).to eq("#{branch}\n#{commit}\n#{message}\n#{author}")
      expect(responce.body[0]['commit']).to eq('Fix bug 39463')
      expect(result_bug['status']).to eq('RESOLVED')
      expect(result_bug['resolution']).to eq('FIXED')
    end
  end
end
