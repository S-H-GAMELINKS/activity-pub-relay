require "rails_helper"

RSpec.describe Actor, type: :model do
  describe ".key" do
    let(:path) { Rails.root.join("config/actor.pem") }

    it "should return public key pem" do
      expected_public_key_pem = OpenSSL::PKey::RSA.new(path.read).public_key.to_pem

      expect(expected_public_key_pem).to eq Actor.key.public_key.to_pem
    end
  end
end
