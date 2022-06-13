# frozen_string_literal: true

require 'spec_helper'

describe HookDetection do
  let(:detection) { described_class.new(nil) }

  describe '#create_full_comment' do
    it 'return a string' do
      commit = instance_double(Commit,
                               message: 'message',
                               url: 'url',
                               author: instance_double(Author, name: 'AuthorName'))
      expect(detection.create_full_comment(commit, 'branch')).to be_a(String)
    end
  end
end
