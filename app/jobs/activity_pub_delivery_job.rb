class ActivityPubDeliveryJob < ApplicationJob
  queue_as :default

  def perform(inbox_url, json)
    response = ActivityPubDeliveryClient.new(inbox_url, json).send

    Rails.logger.info "################################################################"
    Rails.logger.info "#{response.code}: #{response.body}"
    Rails.logger.info "################################################################"
  end
end
