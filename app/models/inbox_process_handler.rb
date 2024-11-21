class InboxProcessHandler
  def call(actor, json)
    activity_pub_type = ActivityPubTypeHandler.new(json).call

    case activity_pub_type
    when :follow
      ServerFollowHandler.new.call(actor, json)
    when :unfollow
      ServerUnfollowHandler.new.call(actor)
    when :valid_for_rebroadcast
      RebroadcastHandler.new.call(actor, json)
    else
    end
  end
end
