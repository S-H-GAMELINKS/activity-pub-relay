# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignatureVerification do
  describe '#signed_request_account' do
    subject(:signature_verification_call) { described_class.call(request) }

    let(:request) do
      Struct.new(:method, :headers, :path, :raw_post).new(method: 'POST', headers:, path: '/inbox',
                                                          raw_post: '{"@context":"https://www.w3.org/ns/activitystreams","id":"https://example.comt/a8fcbecc-c218-44ff-8459-706858e3b82c","type":"Follow","actor":"https://example.com/actor","object":"https://www.w3.org/ns/activitystreams#Public"}')
    end

    context 'with request header have Signature' do
      let(:headers) { { 'Signature' => 'keyId="https://example.com/actor#main-key",algorithm="rsa-sha256",headers="(request-target) host date digest content-type",signature="Wg/22aD3wj4veF7y9i0GTzAZpRvhJKK2mi/IqGqGCJRI5Mj9ARWBG6sNoLmaKl78UyOr5BICVHYS/jp5VjbiqxwwzJq+uqy8A49oxxO8gY23aVl6+iICMM2FWDW+yxvj+5nY4WC5Zu756KzvIXtQKTZCuR1Tp2BzE0oTzPkh40eoXKad4GJj7p5h9JkpuGL/gBbTNqFiNPnMLB1Xy/6idu/q5ul6DrzyY7FF25hqlwg7WN6hbD7Aij/0c0PfJinU5afGOyjXZgkeuI/kYxWWoON++CU0gKKj+2B8ONL7UzMaXz6b95b/9XnOXZw+PAXUpxGEMQYUvZotLTHw6D914w=="' } }

      it 'return account' do
        expect(signature_verification_call).to be true
      end
    end

    context 'with request header not have Signature' do
      let(:headers) { {} }

      it 'return nil' do
        expect(signature_verification_call).to be_nil
      end
    end
  end
end
