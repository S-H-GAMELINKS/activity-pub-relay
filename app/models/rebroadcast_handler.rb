class RebroadcastHandler
  def call(actor, json)
    domain = URI.parse(actor["id"]).normalize.host
    activity_delivery_jobs = active_servers(domain).map { |_, inbox_url| ActivityPubDeliveryJob.new(inbox_url, json) }

    ActiveJob.perform_all_later(activity_delivery_jobs)

    Rails.logger.info "#################################################"
    Rails.logger.info "Done"
    Rails.logger.info "#################################################"
  end

  private

  def active_servers(domain)
    records = SubscribeServer.pluck(:domain, :inbox_url)
    records.reject! { |record_domain, _| record_domain == domain }
    records
  end
end
