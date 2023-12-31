# frozen_string_literal: true

# :nodoc:
class WebfingerController < ApplicationController
  def show
    render content_type: 'application/activity+json', json: {
      subject: acct,
      links: [{
        rel: 'self',
        type: 'application/activity+json',
        href: actor_url
      }]
    }
  end

  private

  def acct
    "acct:relay@#{ENV.fetch('DOMAIN') { "localhost:#{ENV.fetch('PORT', 3000)}" }}"
  end
end
