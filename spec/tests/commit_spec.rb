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
      expect(responce.body[commit_req['commits'][0]['id']].key?('test_action')).to be_truthy
    end
  end

  describe 'Actions' do

    it 'check add_comment action' do
      bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
      bugzilla.update_bug(StaticData::BUG_ID_TEST, status: 'NEW')
      commit_req = StaticData.commit
      commit_req['ref'] = 'refs/heads/develop'
      commit_req['commits'][0]['message'] = 'bug 39463'
      commit_req['html_url'] = "https://githubb-fake-rebo/#{Faker::Dota.hero}"
      commit_req['commits'][0]['author']['name'] = Faker::StarWars.character
      responce = http.post_request(params: commit_req)
      sleep 10
      result_bug = bugzilla.bug_data(StaticData::BUG_ID_TEST)
      result_comments = bugzilla.comments(StaticData::BUG_ID_TEST)
      branch = "Commit pushed to #{commit_req['ref']}"
      commit = commit_req['commits'][0]['url']
      message = "Message: #{commit_req['commits'][0]['message']}"
      author = "Author: #{commit_req['commits'][0]['author']['name']}"
      responce_commit = responce.body[commit_req['commits'][0]['id']]
      expect(result_comments.last['text']).to eq("#{branch}\n#{commit}\n#{message}\n#{author}")
      expect(responce_commit['commit_message']).to eq(commit_req['commits'][0]['message'])
      expect(responce_commit['add_comment']['comment']).to eq("#{branch}\n#{commit}\n#{message}\n#{author}")
      expect(result_bug['status']).to eq('NEW')
    end

    it 'check add_resolved_fixed and add_comment actions' do
      bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
      bugzilla.update_bug(StaticData::BUG_ID_TEST, status: 'NEW')
      commit_req = StaticData.commit
      commit_req['ref'] = 'refs/heads/develop'
      commit_req['commits'][0]['message'] = 'Fix bug 39463'
      commit_req['html_url'] = "https://githubb-fake-rebo/#{Faker::Dota.hero}"
      commit_req['commits'][0]['author']['name'] = Faker::StarWars.character
      responce = http.post_request(params: commit_req)
      sleep 10
      result_bug = bugzilla.bug_data(StaticData::BUG_ID_TEST)
      result_comments = bugzilla.comments(StaticData::BUG_ID_TEST)
      branch = "Commit pushed to #{commit_req['ref']}"
      commit = commit_req['commits'][0]['url']
      message = "Message: #{commit_req['commits'][0]['message']}"
      author = "Author: #{commit_req['commits'][0]['author']['name']}"
      expect(result_comments.last['text']).to eq("#{branch}\n#{commit}\n#{message}\n#{author}")
      expect(responce.body[commit_req['commits'][0]['id']].key?('add_comment')).to be_truthy
      expect(responce.body[commit_req['commits'][0]['id']]['bug_id']).to eq(StaticData::BUG_ID_TEST)
      expect(responce.body[commit_req['commits'][0]['id']]['add_comment']['comment']).to eq(result_comments.last['text'])
      expect(responce.body[commit_req['commits'][0]['id']]['commit_message']).to eq(commit_req['commits'][0]['message'])
      expect(result_bug['status']).to eq('RESOLVED')
      expect(result_bug['resolution']).to eq('FIXED')
    end
  end

  describe 'status change' do
    it 'check only comment if not new or reopen status' do
      bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
      bugzilla.update_bug(StaticData::BUG_ID_TEST, status: 'RESOLVED',
                                                   resolution: 'FIXED')
      bugzilla.update_bug(StaticData::BUG_ID_TEST, status: 'VERIFIED')
      commit_req = StaticData.commit
      commit_req['repository']['name'] = 'sdkjs'
      commit_req['commits'][0]['message'] = 'Fix bug 39463'
      commit_req['html_url'] = "https://githubb-fake-rebo/#{Faker::Dota.hero}"
      commit_req['commits'][0]['author']['name'] = Faker::StarWars.character
      responce = http.post_request(params: commit_req)
      sleep 10
      result_bug = bugzilla.bug_data(StaticData::BUG_ID_TEST)
      result_comments = bugzilla.comments(StaticData::BUG_ID_TEST)

      branch = "Commit pushed to #{commit_req['ref']}"
      commit = commit_req['commits'][0]['url']
      message = "Message: #{commit_req['commits'][0]['message']}"
      author = "Author: #{commit_req['commits'][0]['author']['name']}"
      expect(result_comments.last['text']).to eq("#{branch}\n#{commit}\n#{message}\n#{author}")
      expect(responce.body[commit_req['commits'][0]['id']]['commit_message']).to eq(commit_req['commits'][0]['message'])
      expect(result_bug['status']).to eq('VERIFIED')
      expect(result_bug['resolution']).to eq('FIXED')
    end

    it 'change status if reopened' do
      bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
      bugzilla.update_bug(StaticData::BUG_ID_TEST, status: 'RESOLVED',
                                                   resolution: 'FIXED')
      bugzilla.update_bug(StaticData::BUG_ID_TEST, status: 'REOPENED')
      commit_req = StaticData.commit
      commit_req['repository']['name'] = 'sdkjs'
      commit_req['commits'][0]['message'] = 'Fix bug 39463'
      commit_req['html_url'] = "https://githubb-fake-rebo/#{Faker::Dota.hero}"
      commit_req['commits'][0]['author']['name'] = Faker::StarWars.character
      responce = http.post_request(params: commit_req)
      sleep 10
      result_bug = bugzilla.bug_data(StaticData::BUG_ID_TEST)
      result_comments = bugzilla.comments(StaticData::BUG_ID_TEST)

      branch = "Commit pushed to #{commit_req['ref']}"
      commit = commit_req['commits'][0]['url']
      message = "Message: #{commit_req['commits'][0]['message']}"
      author = "Author: #{commit_req['commits'][0]['author']['name']}"
      expect(result_comments.last['text']).to eq("#{branch}\n#{commit}\n#{message}\n#{author}")
      expect(responce.body[commit_req['commits'][0]['id']]['commit_message']).to eq(commit_req['commits'][0]['message'])
      expect(result_bug['status']).to eq('RESOLVED')
      expect(result_bug['resolution']).to eq('FIXED')
    end

    it 'change status if assigned' do
      bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
      bugzilla.update_bug(StaticData::BUG_ID_TEST, status: 'ASSIGNED')
      commit_req = StaticData.commit
      commit_req['repository']['name'] = 'sdkjs'
      commit_req['commits'][0]['message'] = 'Fix bug 39463'
      commit_req['html_url'] = "https://githubb-fake-rebo/#{Faker::Dota.hero}"
      commit_req['commits'][0]['author']['name'] = Faker::StarWars.character
      responce = http.post_request(params: commit_req)
      sleep 10
      result_bug = bugzilla.bug_data(StaticData::BUG_ID_TEST)
      result_comments = bugzilla.comments(StaticData::BUG_ID_TEST)

      branch = "Commit pushed to #{commit_req['ref']}"
      commit = commit_req['commits'][0]['url']
      message = "Message: #{commit_req['commits'][0]['message']}"
      author = "Author: #{commit_req['commits'][0]['author']['name']}"
      expect(result_comments.last['text']).to eq("#{branch}\n#{commit}\n#{message}\n#{author}")
      expect(responce.body[commit_req['commits'][0]['id']]['commit_message']).to eq(commit_req['commits'][0]['message'])
      expect(result_bug['status']).to eq('RESOLVED')
      expect(result_bug['resolution']).to eq('FIXED')
    end
  end
end
