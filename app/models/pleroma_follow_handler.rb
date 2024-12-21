class PleromaFollowHandler
  def initialize(actor, json)
    @actor = actor
    @json = json
  end

  def call
    inbox_url = @actor["inbox"]

    response = send_accept_activity(inbox_url)

    return unless response.code == "200"

    Rails.logger.info "#{response.code}: #{response.body}"

    response = send_follow_activity(inbox_url)

    if response.code == "200"
      domain = URI.parse(@actor["id"]).normalize.host
      SubscribeServer.create!(domain:, inbox_url:)
    end

    Rails.logger.info "#{response.code}: #{response.body}"
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error e.full_message
  end

  private

  def send_accept_activity(inbox_url)
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

    ActivityPubDeliveryClient.new(inbox_url, accept_activity).send
  end

  def send_follow_activity(inbox_url)
    follow_activity = {
      "@context": [
        "https://www.w3.org/ns/activitystreams",
        "https://w3id.org/security/v1"
      ],
      id: "https://#{ENV['LOCAL_DOMAIN']}/actor#accepts/follows",
      type: "Follow",
      actor: "https://#{ENV['LOCAL_DOMAIN']}/actor",
      object: @actor["id"]
    }.to_json

    ActivityPubDeliveryClient.new(inbox_url, follow_activity).send
  end
end
