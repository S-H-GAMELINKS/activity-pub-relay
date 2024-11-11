require "test_helper"

class ActorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    unless File.exist?(Rails.root.join("config/actor.pem"))
      Relay::Keygen.run
    end

    get "/actor"
  end

  test "return http success" do
    assert_response :success
  end

  test "return json" do
    expected_public_key_pem = OpenSSL::PKey::RSA.new(Rails.root.join("config/actor.pem").read).public_key.to_pem

    expected_json = {
      "@context" => [
        "https://www.w3.org/ns/activitystreams",
        "https://w3id.org/security/v1"
      ],
      "id" => "http://www.example.com/actor",
      "type" => "Service",
      "preferredUsername" => "relay",
      "inbox" => "", # TODO: set inbox endpoint
      "publicKey" => {
        "id" => "http://www.example.com/actor#main-key",
        "owner" => "http://www.example.com/actor",
        "publicKeyPem" => expected_public_key_pem
      }
    }

    response_json = JSON.parse(response.body)

    assert_equal expected_json, response_json
  end

  test "return content-type is 'application/activity+json'" do
    assert_equal "application/activity+json; charset=utf-8", response.content_type
  end

  teardown do
    if File.exist?(Rails.root.join("config/actor.pem"))
      FileUtils.rm_rf(Rails.root.join("config/actor.pem"))
    end
  end
end
