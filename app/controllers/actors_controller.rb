class ActorsController < ApplicationController
  def show
    render json: {
      "@context": %w[https://www.w3.org/ns/activitystreams https://w3id.org/security/v1],
      id: actor_url,
      type: "Service",
      preferredUsername: "relay",
      inbox: "", # TODO: set inbox endpoint
      publicKey: {
        id: "#{actor_url}#main-key",
        owner: actor_url,
        publicKeyPem: Actor.key.public_key.to_pem
      }
    }, content_type: "application/activity+json"
  end
end
