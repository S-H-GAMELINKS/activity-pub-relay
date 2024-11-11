require "test_helper"

class Relay::KeygenTest < ActiveSupport::TestCase
  setup do
    Relay::Keygen.run
  end

  test "generate actor signature key" do
    path = Rails.root.join("config/actor.pem")
    assert true, File.exist?(path)
  end

  teardown do
    path = Rails.root.join("config/actor.pem")
    if File.exist?(path)
      FileUtils.rm_rf(path)
    end
  end
end
