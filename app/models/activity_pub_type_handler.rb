class ActivityPubTypeHandler
  PUBLIC_COLLECTION = "https://www.w3.org/ns/activitystreams#Public"

  def initialize(json)
    @json = json
  end

  def call
    if follow?
      :follow
    elsif unfollow?
      :unfollow
    elsif valid_for_rebroadcast?
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
    signed? && addressed_to_public? && supported_type?
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
end
