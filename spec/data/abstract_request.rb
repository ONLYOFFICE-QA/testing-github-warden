require 'json'
module AbstractRequest
  def commit
    file = File.read(File.join(File.dirname(__FILE__), './request_object/commit.json'))
    JSON.parse(file)
  end
end
