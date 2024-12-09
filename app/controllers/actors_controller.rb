class ActorsController < ApiController
  def show
    render json: {
      "@context": %w[https://www.w3.org/ns/activitystreams https://w3id.org/security/v1],
      id: "https://#{ENV.fetch("LOCAL_DOMAIN", "www.example.com")}/actor",
      type: "Service",
      preferredUsername: "relay",
      inbox: "https://#{ENV.fetch("LOCAL_DOMAIN", "www.example.com")}/inbox",
      publicKey: {
        id: "https://#{ENV.fetch("LOCAL_DOMAIN", "www.example.com")}/actor#main-key",
        owner: "https://#{ENV.fetch("LOCAL_DOMAIN", "www.example.com")}/actor",
        publicKeyPem: Actor.key.public_key.to_pem
      }
    }, content_type: "application/activity+json"
  end
end
