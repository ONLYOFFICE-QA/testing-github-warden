# frozen_string_literal: true

# Class for description of Request token
class RequestToken
  def initialize(request)
    @request = request
  end

  # @return [Symbol] type of sender
  def sender_type
    return @sender_type if @sender_type

    @sender_type = if @request.env.key?('HTTP_X_HUB_SIGNATURE')
                     :github
                   elsif @request.env.key?('HTTP_X_GITLAB_TOKEN')
                     :gitlab
                   end

    @sender_type
  end

  # @return [String, nil] token of request
  def request_signature
    return @request.env['HTTP_X_HUB_SIGNATURE'] if sender_type == :github
    return @request.env['HTTP_X_GITLAB_TOKEN'] if sender_type == :gitlab

    nil
  end

  # @return [String] signature of request
  def warden_signature
    if sender_type == :github
      return "sha1=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'),
                                             ENV.fetch('SECRET_TOKEN', ''),
                                             @request.body.read)}"
    end

    ENV.fetch('SECRET_TOKEN', '')
  end
end
