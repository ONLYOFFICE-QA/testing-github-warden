# frozen_string_literal: true

require 'spec_helper'

describe RequestToken do
  let(:github_request) do
    instance_double(Sinatra::Request,
                    env: { 'HTTP_X_HUB_SIGNATURE' => 'sha1=123456' },
                    body: instance_double(StringIO, read: 'Test'))
  end
  let(:gitlab_request) { instance_double(Sinatra::Request, env: { 'HTTP_X_GITLAB_TOKEN' => '123456' }) }

  describe 'RequestToken for Github' do
    let(:request_token) { described_class.new(github_request) }

    it 'sender_type should return :github' do
      expect(request_token.sender_type).to eq(:github)
    end

    it 'request_signature should return signature' do
      expect(request_token.request_signature).to eq(github_request.env['HTTP_X_HUB_SIGNATURE'])
    end

    it 'warden_signature should start with sha1' do
      expect(request_token.warden_signature).to start_with('sha1=')
    end
  end

  describe 'RequestToken for GitLab' do
    let(:request_token) { described_class.new(gitlab_request) }

    it 'sender_type should return :gitlab' do
      expect(request_token.sender_type).to eq(:gitlab)
    end

    it 'request_signature should return signature' do
      expect(request_token.request_signature).to eq(gitlab_request.env['HTTP_X_GITLAB_TOKEN'])
    end

    it 'warden_signature should start with sha1' do
      expect(request_token.warden_signature).not_to start_with('sha1=')
    end
  end
end
