# frozen_string_literal: true

require_relative '../test_management'

http = nil
describe 'Commit smoke' do
  before :each do
    http = Http.new
  end

  describe 'status change' do
    StaticData::CHANGE_STATUS_AND_COMMENT.each do |commit_message|
      it "check '#{commit_message}' message for add status and comment" do
        commit_req = StaticData.commit
        commit_req['commits'][0]['message'] = commit_message
        commit_req['ref'] = 'refs/heads/test_branch_first'
        commit_req['html_url'] = 'https://githubb-fake-rebo/test'
        commit_req['commits'][0]['author']['name'] = Faker::Movies::StarWars.character
        responce = http.post_request(params: commit_req)
        responce_commit = responce.body[commit_req['commits'][0]['id']]
        result = responce_commit.find do |element|
          element['commit_message'] == commit_message &&
            element['bug_id'] == StaticData::BUG_ID_TEST &&
            element['action'] == 'add_resolved_fixed'
        end
        expect(result).not_to be_empty
      end
    end
  end

  describe 'status not change' do
    StaticData::COMMENT_ONLY.each do |commit_message|
      it "check '#{commit_message}' message for add status and comment" do
        commit_req = StaticData.commit
        commit_req['commits'][0]['message'] = commit_message
        commit_req['ref'] = 'refs/heads/test_branch_first'
        commit_req['html_url'] = 'https://githubb-fake-rebo/test'
        commit_req['commits'][0]['author']['name'] = Faker::Movies::StarWars.character
        responce = http.post_request(params: commit_req)
        responce_commit = responce.body[commit_req['commits'][0]['id']]
        result = responce_commit.find do |element|
          element['commit_message'] == commit_message &&
            element['bug_id'] == StaticData::BUG_ID_TEST &&
            element['action'] == 'add_comment'
        end
        expect(result).not_to be_empty
      end
    end
  end

  describe 'do nothing' do
    StaticData::DO_NOTHING.each do |commit_message|
      it "check '#{commit_message}' message for do nothing" do
        commit_req = StaticData.commit
        commit_req['commits'][0]['message'] = commit_message
        commit_req['html_url'] = "https://githubb-fake-rebo/#{Faker::Games::Dota.hero}"
        commit_req['commits'][0]['author']['name'] = Faker::Movies::StarWars.character
        responce = http.post_request(params: commit_req)
        expect(responce.body).to be_empty
        expect(responce.code).to eq('200')
      end
    end
  end
end
