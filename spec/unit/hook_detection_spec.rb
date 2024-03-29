# frozen_string_literal: true

require 'spec_helper'

describe HookDetection do
  let(:commit) do
    instance_double(Commit,
                    message: 'message',
                    url: 'url',
                    author: instance_double(Author, name: 'AuthorName'))
  end
  let(:detection) do
    described_class.new(instance_double(GithubResponceObjects,
                                        commits: [commit]))
  end

  describe '#create_full_comment' do
    it 'return a string' do
      expect(detection.create_full_comment(commit, 'branch')).to be_a(String)
    end
  end

  describe '#find_action' do
    it 'by default it return nothing' do
      expect(detection.find_action).to eq({})
    end
  end
end
