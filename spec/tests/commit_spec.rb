require_relative '../test_management'

http = nil
describe 'Commit smoke' do
  before :each do
    http = Http.new
  end

  describe 'One commit smoke' do
    it 'one commit | do nothing' do
      responce = http.post_request(StaticData.commit)
      expect(responce.body).to be_empty
    end

    it 'one commit | only repository match' do
      commit_req = StaticData.commit
      commit_req['repository']['name'] = 'test_repo'
      responce = http.post_request(commit_req)
      expect(responce.body).to be_empty
    end

    it 'one commit | only repository and branch match' do
      commit_req = StaticData.commit
      commit_req['repository']['name'] = 'test_repo'
      commit_req['ref'] = 'refs/heads/test_branch'
      responce = http.post_request(commit_req)
      expect(responce.body).to be_empty
    end

    it 'one commit | test_action' do
      commit_req = StaticData.commit
      commit_req['repository']['name'] = 'test_repo'
      commit_req['ref'] = 'refs/heads/test_branch'
      commit_req['commits'][0]['message'] = 'test_commit_message'
      responce = http.post_request(commit_req)
      expect(responce.body[0]['action']).to eq('test_action')
      expect(responce.body[0]['commit']).to eq('test_commit_message')
    end
  end
end
