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
        sleep 5
        bugzilla.update_bug(StaticData::BUG_ID_TEST, status: 'NEW')
        commit_req = StaticData.commit
        commit_req['commits'][0]['message'] = commit_message
        commit_req['html_url'] = "https://githubb-fake-rebo/#{Faker::Dota.hero}"
        commit_req['commits'][0]['author']['name'] = Faker::StarWars.character
        responce = http.post_request(params: commit_req)
        expect(responce.body[0]['commit']).to eq(commit_message)
        expect(responce.body[0]['status_change']).to be_truthy
      end
    end
  end

  describe 'status not change' do
    StaticData::COMMENT_ONLY.each do |commit_message|
      it "check '#{commit_message}' message for add status and comment" do
        bugzilla.update_bug(StaticData::BUG_ID_TEST, status: 'NEW')
        sleep 5
        commit_req = StaticData.commit
        commit_req['commits'][0]['message'] = commit_message
        commit_req['html_url'] = "https://githubb-fake-rebo/#{Faker::Dota.hero}"
        commit_req['commits'][0]['author']['name'] = Faker::StarWars.character
        responce = http.post_request(params: commit_req)
        expect(responce.body[0]['commit']).to eq(commit_message)
        expect(responce.body[0]['status_change']).to be_falsey
      end
    end
  end

end
