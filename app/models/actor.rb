class Actor
  def self.key
    OpenSSL::PKey::RSA.new(Rails.root.join("config/actor.pem").read)
  end
end
