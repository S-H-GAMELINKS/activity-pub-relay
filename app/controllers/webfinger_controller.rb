class WebfingerController < ApplicationController
  def show
    render json: {
      subject: acct,
      links: [ {
        rel: "self",
        type: "application/activity+json",
        href: "" # TODO: set actor endpoint
      } ]
    }, content_type: "application/activity+json"
  end

  private

  def acct
    "acct:relay@#{ENV.fetch('DOMAIN') { "localhost:#{ENV.fetch('PORT', 3000)}" }}"
  end
end
