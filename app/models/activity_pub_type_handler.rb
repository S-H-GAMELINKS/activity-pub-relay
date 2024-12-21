class ActivityPubTypeHandler
  PUBLIC_COLLECTION = "https://www.w3.org/ns/activitystreams#Public"

  def initialize(actor, json)
    @actor = actor
    @json = json
  end

  def call
    if follow?
      :follow
    elsif unfollow?
      :unfollow
    elsif valid_for_rebroadcast?
      :valid_for_rebroadcast
    elsif pleroma_relay_announce?
      :valid_for_rebroadcast
    else
      :none
    end
  end

  private

  def follow?
    @json["type"] == "Follow"
  end

  def unfollow?
    @json["type"] == "Undo" && @json["object"]["type"] == "Follow"
  end

  def valid_for_rebroadcast?
    if ENV["ALLOWED_HASHTAGS"].present?
      signed? && addressed_to_public? && supported_type? && has_allowed_hashtags?
    else
      signed? && addressed_to_public? && supported_type?
    end
  end

  def signed?
    @json["signature"].present?
  end

  def addressed_to_public?
    (Array(@json["to"]) + Array(@json["cc"])).include?(PUBLIC_COLLECTION)
  end

  def supported_type?
    !(Array(@json["type"]) & %w[Create Update Delete Announce Undo]).empty?
  end

  def has_allowed_hashtags?
    if @json["object"].present? && @json["object"]["tag"].present?
      hashtags = @json["object"]["tag"].map do |hashtag|
        hashtag["name"].downcase if hashtag["type"] == "Hashtag"
      end

      allowed_hashtags = ENV["ALLOWED_HASHTAGS"].split(",")

      hashtags.inquiry.any?(*allowed_hashtags)
    else
      false
    end
  end

  def pleroma_relay_announce?
    @actor["preferredUsername"] == "relay" && @json["type"] == "Announce"
  end
end
