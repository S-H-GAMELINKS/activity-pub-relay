class ServerFollowHandler
  def call(actor, json)
    if actor["preferredUsername"].present? && actor["preferredUsername"] == "relay"
      PleromaFollowHandler.new(actor, json).call
    else
      MastodonFollowHandler.new(actor, json).call
    end
  end
end
