# frozen_string_literal: true

require 'rails_helper'

describe '/actor' do
  let(:actor_public_key_pem) { OpenSSL::PKey::RSA.new(Rails.root.join('config/actor.pem').read) }

  before do
    get '/actor'
  end

  it 'returns http success' do
    expect(response).to have_http_status(:ok)
  end

  it 'return application/activity+json' do
    expect(response.content_type).to eq('application/activity+json; charset=utf-8')
  end

  it 'return json' do
    expect(response.body).to be_json_sym(
      '@context': [
        'https://www.w3.org/ns/activitystreams',
        'https://w3id.org/security/v1'
      ],
      id: 'http://www.example.com/actor',
      type: 'Service',
      preferredUsername: 'relay',
      inbox: '', # TODO: set inbox endpoint
      publicKey: {
        id: 'http://www.example.com/actor#main-key',
        owner: 'http://www.example.com/actor',
        publicKeyPem: actor_public_key_pem.public_key.to_pem
      }
    )
  end
end
