# frozen_string_literal: true

require_relative '../test_management'

http = nil
describe 'Secure smoke' do
  before :each do
    http = Http.new
  end

  describe 'Secure' do
    it 'Secure | ping' do
      responce = http.post_request(params: StaticData.ping)
      expect(responce.body).to be_nil
    end

    it 'Secure | no headers' do
      responce = http.post_request(params: StaticData.commit, no_headers: true)
      expect(responce.body['errors'].size).to eq(1)
      expect(responce.body['errors'][0]).to eq('No HTTP_X_HUB_SIGNATURE')
    end

    it 'Secure | wrong signature' do
      responce = http.post_request(params: StaticData.commit,
                                   headers: { 'X_HUB_SIGNATURE' => StaticData::WRONG_HTTP_X_HUB_SIGNATURE })
      expect(responce.body['errors'].size).to eq(1)
      expect(responce.body['errors'][0]).to eq('Wrong signatures')
    end
  end
end
