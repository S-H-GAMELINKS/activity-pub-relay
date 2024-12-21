class MastodonFollowHandler
  def initialize(actor, json)
    @actor = actor
    @json = json
  end

  def call
    inbox_url = @actor["endpoints"].is_a?(Hash) && @actor["endpoints"]["sharedInbox"].present? ? @actor["endpoints"]["sharedInbox"] : @actor["inbox"]

    domain = URI.parse(@actor["id"]).normalize.host

    accept_activity = {
      "@context": [
        "https://www.w3.org/ns/activitystreams",
        "https://w3id.org/security/v1"
      ],
      id: URI.join("https://#{ENV['LOCAL_DOMAIN']}/actor#accepts/follows/#{URI.parse(@actor['id']).normalize.host}"),
      type: "Accept",
      actor: "https://#{ENV['LOCAL_DOMAIN']}/actor",
        object: {
          id: @json["id"],
          type: "Follow",
          actor: @actor["id"],
          object: "https://#{ENV['LOCAL_DOMAIN']}/actor"
        }
    }.to_json

    response = ActivityPubDeliveryClient.new(inbox_url, accept_activity).send

    if response.code == "202"
      SubscribeServer.create!(domain:, inbox_url:)
    end

    Rails.logger.info "#{response.code}: #{response.body}"
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error e.full_message
  end
end
