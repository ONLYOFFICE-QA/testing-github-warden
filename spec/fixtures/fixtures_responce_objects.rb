# frozen_string_literal: true

require 'json'
module FixturesResponceObjects
  def commit
    file = File.read(File.join(File.dirname(__FILE__), './fixtures_responce_objects/commit.json'))
    JSON.parse(file)
  end

  def ping
    file = File.read(File.join(File.dirname(__FILE__), './fixtures_responce_objects/ping.json'))
    JSON.parse(file)
  end

  def repo_match_commit
    file = File.read(File.join(File.dirname(__FILE__), './fixtures_responce_objects/repo_match_commit.json'))
    JSON.parse(file)
  end
end
