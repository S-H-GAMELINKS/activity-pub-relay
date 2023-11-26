# frozen_string_literal: true

require 'rails_helper'

describe '/inbox' do
  context 'with not blocked domain' do
    before do
      post '/inbox', params: { domain: 'example.com' }, headers: { Signature: 'keyId="https://example.com/actor#main-key",algorithm="rsa-sha256",headers="(request-target) host date digest content-type",signature="Wg/22aD3wj4veF7y9i0GTzAZpRvhJKK2mi/IqGqGCJRI5Mj9ARWBG6sNoLmaKl78UyOr5BICVHYS/jp5VjbiqxwwzJq+uqy8A49oxxO8gY23aVl6+iICMM2FWDW+yxvj+5nY4WC5Zu756KzvIXtQKTZCuR1Tp2BzE0oTzPkh40eoXKad4GJj7p5h9JkpuGL/gBbTNqFiNPnMLB1Xy/6idu/q5ul6DrzyY7FF25hqlwg7WN6hbD7Aij/0c0PfJinU5afGOyjXZgkeuI/kYxWWoON++CU0gKKj+2B8ONL7UzMaXz6b95b/9XnOXZw+PAXUpxGEMQYUvZotLTHw6D914w=="' }
    end

    it 'returns http accepted' do
      expect(response).to have_http_status(:accepted)
    end
  end

  context 'with blocked domain' do
    before do
      create(:block, domain: 'example.com')
      post '/inbox', params: { domain: 'example.com' }
    end

    it 'returns http 401' do
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
