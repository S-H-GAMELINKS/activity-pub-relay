class RebroadcastHandler
  def call(actor, json)
    domain = URI.parse(actor["id"]).normalize.host

    activity_delivery_jobs = active_servers(domain).map do |_, inbox_url, _, _|
      ActivityPubDeliveryJob.new(inbox_url, announce_json(json["object"]))
    end

    return if activity_delivery_jobs.empty?

    ActiveJob.perform_all_later(activity_delivery_jobs)

    RebroadcastCounter.increment
  end

  private

  def active_servers(domain)
    records = SubscribeServer.pluck(:domain, :inbox_url, :delivery_suspend, :domain_block)
    records.reject! { |record_domain, _, delivery_suspend, domain_block|
      record_domain == domain || delivery_suspend || domain_block
    }
    records
  end

  def announce_json(object)
    {
      "@context" => "https://www.w3.org/ns/activitystreams",
      "id" => "https://#{ENV["LOCAL_DOMAIN"]}/actor##{SecureRandom.uuid}",
      "type" => "Announce",
      "actor" => "https://#{ENV["LOCAL_DOMAIN"]}/actor",
      "object" => object,
      "to" => [ "https://www.w3.org/ns/activitystreams#Public" ],
      "published" => Time.now.utc.httpdate
    }.to_json
  end
end
