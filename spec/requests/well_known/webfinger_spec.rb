# frozen_string_literal: true

require 'rails_helper'

describe '/.well-known/webfinger endpoint' do
  before do
    get '/.well-known/webfinger'
  end

  it 'return http success' do
    expect(response).to have_http_status(:ok)
  end

  it 'return application/activity+json' do
    expect(response.content_type).to eq('application/activity+json; charset=utf-8')
  end

  it 'return json' do
    expect(response.body).to be_json_sym(
      subject: 'acct:relay@localhost:3000',
      links: [
        {
          rel: 'self',
          type: 'application/activity+json',
          href: actor_url
        }
      ]
    )
  end
end
