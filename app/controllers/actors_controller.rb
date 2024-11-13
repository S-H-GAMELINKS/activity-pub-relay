class ActorsController < ApplicationController
  def show
    render json: {
      "@context": %w[https://www.w3.org/ns/activitystreams https://w3id.org/security/v1],
      id: "https://www.example.com/actor",
      type: "Service",
      preferredUsername: "relay",
      inbox: "https://www.example.com/inbox",
      publicKey: {
        id: "https://www.example.com/#main-key",
        owner: "https://www.example.com",
        publicKeyPem: Actor.key.public_key.to_pem
      }
    }, content_type: "application/activity+json"
  end
end
