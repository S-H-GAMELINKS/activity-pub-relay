class ActivityPubDeliveryClient
  def initialize(url, body)
    @url = url
    @body = body
    @date = Time.now.utc.httpdate
  end

  def send
    Net::HTTP.post(
      url,
      @body,
      {
        'Host': host,
        'Date': @date,
        'Digest': digest,
        'Signature': header,
        'User-Agent': user_agent,
        'Content-Type': content_type
      }
    )
  end

  private

  def actor_url
   "#{ENV.fetch('DOMAIN') { "localhost:#{ENV.fetch('PORT', 3000)}" } }"
  end

  def url
    URI.parse(@url)
  end

  def normalized_url
    url.normalize
  end

  def host
    normalized_url.host
  end

  def user_agent
    "activity-pub-relay"
  end

  def content_type
    "application/ld+json;profile=\"https://www.w3.org/ns/activitystreams\""
  end

  def digest
    "SHA-256=#{Digest::SHA256.base64digest(@body)}"
  end

  def signature
    signed_string = "(request-target): post #{normalized_url.path}\nhost: #{host}\ndate: #{@date}\ndigest: #{digest}"
    Base64.strict_encode64(Actor.key.sign(OpenSSL::Digest::SHA256.new, signed_string))
  end

  def header
    "keyId=\"#{actor_url}\",algorithm=\"rsa-sha256\",headers=\"(request-target) host date digest\",signature=\"#{signature}\""
  end
end
