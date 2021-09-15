# frozen_string_literal: true

require 'spec_helper'

describe Author do
  let(:author) { described_class.new(StaticData.commit['commits'].first) }

  it 'author.name should return name' do
    expect(author.name).to eq('Dmitriy Rotatyy')
  end

  it 'author.email should return email' do
    expect(author.email).to eq('flamine@list.ru')
  end

  it 'author.username should return username' do
    expect(author.username).to eq('flaminestone')
  end
end
