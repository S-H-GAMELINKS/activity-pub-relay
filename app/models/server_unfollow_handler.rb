class ServerUnfollowHandler
  def call(actor)
    domain = URI.parse(actor["id"]).normalize.host

    SubscribeServer.where(domain:).destroy_all
  end
end
