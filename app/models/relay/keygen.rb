class Relay::Keygen
  def self.run
    key = OpenSSL::PKey::RSA.new(2048)
    Rails.root.join("config/actor.pem").write(key.to_pem)
  end
end
