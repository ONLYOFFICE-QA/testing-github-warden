class Commit
  attr_accessor :id, :message, :url, :author
  def initialize(params)
    @id = params['id']
    @message = params['message']
    @timestamp = params['timestamp']
    @url = params['url']
  end
end
