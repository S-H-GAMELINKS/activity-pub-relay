# frozen_string_literal: true

# :nodoc:
class Actor
  mattr_accessor :key
  @@key = OpenSSL::PKey::RSA.new(Rails.root.join('config/actor.pem').read)
end
