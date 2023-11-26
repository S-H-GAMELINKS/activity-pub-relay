# frozen_string_literal: true

class SignatureVerification
  def self.call(request)
    new(request).signed_request_account
  end

  def initialize(request)
    @request = request
  end

  def signed_request_account
    return nil if @request.headers['Signature'].blank?

    signature_params = generate_signature_params(@request.headers['Signature'])

    if signature_params['keyId'].blank? || signature_params['signature'].blank?
      return nil
    end

    account = account_from_key_id(signature_params['keyId'])

    signature             = Base64.decode64(signature_params['signature'])
    compare_signed_string = build_signed_string(signature_params['headers'])

    true
  end

  private

  def generate_signature_params(raw_signature)
    signature_params = {}

    raw_signature.split(',').each do |part|
      parsed_parts = part.match(/([a-z]+)="([^"]+)"/i)
      next if parsed_parts.nil? || parsed_parts.size != 3
      signature_params[parsed_parts[1]] = parsed_parts[2]
    end

    return signature_params
  end

  def optional_fetch(url)
    ::HTTP.headers('Accept' => 'application/activity+json, application/ld+json')
        .get(url)
        .to_s
  end

  def account_from_key_id(key_id)
    json = optional_fetch(key_id)

    if json && json['publicKeyPem']
      actor = optional_fetch(json['owner'])
      actor['publicKey'] = json
      actor
    else
      json
    end
  end

  def build_signed_string(signed_headers)
    signed_headers = 'date' if signed_headers.blank?

    signed_headers.split(' ').map do |signed_header|
      if signed_header == '(request-target)'
        "(request-target): #{@request.method.downcase} #{@request.path}"
      elsif signed_header == 'digest'
        "digest: SHA-256=#{Digest::SHA256.base64digest(@request.raw_post)}"
      else
        "#{signed_header}: #{@request.headers[to_header_name(signed_header)]}"
      end
    end.join("\n")
  end

  def to_header_name(name)
    name.split(/-/).map(&:capitalize).join('-')
  end
end
