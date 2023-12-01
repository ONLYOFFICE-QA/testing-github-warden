# frozen_string_literal: true

require 'spec_helper'

describe Repository do
  let(:repo) { described_class.new(Fixtures.commit['repository']) }

  it 'repo.name should return short name of repo' do
    expect(repo.name).to eq('test')
  end

  it 'repo.full_name should return full name of repo' do
    expect(repo.full_name).to eq('flaminestone/test')
  end
end
