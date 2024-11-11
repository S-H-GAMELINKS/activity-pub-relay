require "test_helper"

class ActorTest < ActiveSupport::TestCase
  setup do
    Relay::Keygen.run
  end

  test "return actor public keyi pem" do
    path = Rails.root.join("config/actor.pem")
    expected_public_key_pem = OpenSSL::PKey::RSA.new(path.read).public_key.to_pem

    assert_equal expected_public_key_pem, Actor.key.public_key.to_pem
  end

  teardown do
    path = Rails.root.join("config/actor.pem")
    if File.exist?(path)
      FileUtils.rm_rf(path)
    end
  end
end
