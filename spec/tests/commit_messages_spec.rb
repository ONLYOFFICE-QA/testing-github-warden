require_relative '../test_management'

http = nil
bugzilla = OnlyofficeBugzillaHelper::BugzillaHelper.new
describe 'Commit smoke' do
  before :each do
    http = Http.new
  end

  describe 'status change' do
    StaticData::CHANGE_STATUS_AND_COMMENT.each do |commit_message|
      it "check '#{commit_message}' message for add status and comment" do
        bugzilla.update_bug(StaticData::BUG_ID_TEST, status: 'NEW')
        commit_req = StaticData.commit
        commit_req['commits'][0]['message'] = commit_message
        commit_req['html_url'] = "https://githubb-fake-rebo/#{Faker::Dota.hero}"
        commit_req['commits'][0]['author']['name'] = Faker::StarWars.character
        responce = http.post_request(params: commit_req)
        responce_commit = responce.body[commit_req['commits'][0]['id']]
        expect(responce_commit['commit_message']).to eq(commit_message)
        expect(responce_commit['bug_id']).to eq(StaticData::BUG_ID_TEST)
        expect(responce_commit['add_comment']['comment']).to be_truthy
      end
    end
  end

  describe 'status not change' do
    StaticData::COMMENT_ONLY.each do |commit_message|
      it "check '#{commit_message}' message for add status and comment" do
        bugzilla.update_bug(StaticData::BUG_ID_TEST, status: 'NEW')
        commit_req = StaticData.commit
        commit_req['commits'][0]['message'] = commit_message
        commit_req['html_url'] = "https://githubb-fake-rebo/#{Faker::Dota.hero}"
        commit_req['commits'][0]['author']['name'] = Faker::StarWars.character
        responce = http.post_request(params: commit_req)
        responce_commit = responce.body[commit_req['commits'][0]['id']]
        expect(responce_commit['commit_message']).to eq(commit_message)
        expect(responce_commit['bug_id']).to eq(StaticData::BUG_ID_TEST)
        expect(responce_commit['add_resolved_fixed']).to be_nil
      end
    end
  end

  describe 'do nothing' do
    StaticData::DO_NOTHING.each do |commit_message|
      it "check '#{commit_message}' message for do nothing" do
        bugzilla.update_bug(StaticData::BUG_ID_TEST, status: 'NEW')
        commit_req = StaticData.commit
        commit_req['commits'][0]['message'] = commit_message
        commit_req['html_url'] = "https://githubb-fake-rebo/#{Faker::Dota.hero}"
        commit_req['commits'][0]['author']['name'] = Faker::StarWars.character
        responce = http.post_request(params: commit_req)
        expect(responce.body).to be_empty
        expect(responce.code).to eq('200')
      end
    end
  end
end
