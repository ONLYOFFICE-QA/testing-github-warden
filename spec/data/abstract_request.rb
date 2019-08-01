require 'json'
module AbstractRequest
  def commit
    file = File.read(File.join(File.dirname(__FILE__), './request_object/commit.json'))
    JSON.parse(file)
  end

  def ping
    file = File.read(File.join(File.dirname(__FILE__), './request_object/ping.json'))
    JSON.parse(file)
  end

  def repo_match_commit
    file = File.read(File.join(File.dirname(__FILE__), './request_object/repo_match_commit.json'))
    JSON.parse(file)
  end
end
