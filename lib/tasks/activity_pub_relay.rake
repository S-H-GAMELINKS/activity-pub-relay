# frozen_string_literal: true

namespace :relay do
  desc 'Generate actor signature key'
  task keygen: :environment do
    key = OpenSSL::PKey::RSA.new(2048)
    Rails.root.join('config/actor.pem').write(key.to_pem)
  end
end
