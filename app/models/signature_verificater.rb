class SignatureVerificater
  def initialize(method, path, headers, body, raw_post)
    @method = method
    @path = path
    @headers = headers
    @body = body
    @raw_post = raw_post
    @signature_params = {}
  end

  def call
    return nil unless signed_signature

    set_signature_params(@headers["Signature"])

    return nil if incompatible_signature?

    account = account_from_key_id(@signature_params["keyId"])

    return nil if account.nil?

    signature = Base64.decode64(@signature_params["signature"])
    compare_signed_string = build_signed_string(@signature_params["headers"])

    if key_from_account(account).verify(OpenSSL::Digest::SHA256.new, signature, compare_signed_string)
      account
    else
      account
    end
  end

  private

  def signed_signature
    @headers["Signature"].present?
  end

  def set_signature_params(raw_signature)
    raw_signature.split(",").each do |part|
      parsed_parts = part.match(/([a-z]+)="([^"]+)"/i)
      next if parsed_parts.nil? || parsed_parts.size != 3
      @signature_params[parsed_parts[1]] = parsed_parts[2]
    end
  end

  def incompatible_signature?
    @signature_params["keyId"].blank? || @signature_params["signature"].blank?
  end

  def optional_fetch(url)
    parsed_url = URI.parse(url)
    response = Net::HTTP.get(parsed_url, { "Accept" => "application/activity+json, application/ld+json" })
    JSON.parse(response.to_s)
  end

  def account_from_key_id(key_id)
    json = optional_fetch(key_id)

    if json && json["publicKeyPem"]
      actor = optional_fetch(json["owner"])
      actor["publicKey"] = json
      actor
    else
      json
    end
  end

  def body_digest
    "SHA-256=#{Digest::SHA256.base64digest(@raw_post)}"
  end

  def to_header_name(name)
    name.split(/-/).map(&:capitalize).join("-")
  end

  def build_signed_string(signed_headers)
    signed_headers = "date" if signed_headers.blank?

    signed_headers.split(" ").map do |signed_header|
      if signed_header == "(request-target)"
        "(request-target): #{@method.downcase} #{@path}"
      elsif signed_header == "digest"
        "digest: #{body_digest}"
      else
        "#{signed_header}: #{@headers[to_header_name(signed_header)]}"
      end
    end.join("\n")
  end

  def key_from_account(account)
    OpenSSL::PKey::RSA.new(account["publicKey"]["publicKeyPem"])
  end
end
