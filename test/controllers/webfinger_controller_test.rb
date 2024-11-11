require "test_helper"

class WebfingerControllerTest < ActionDispatch::IntegrationTest
  setup do
    get "/.well-known/webfinger"
  end
  test "return http success" do
    assert_response :success
  end

  test "return json" do
    expected_json = {
      "subject" => "acct:relay@localhost:3000",
      "links" => [
        {
          "rel" => "self",
          "type" => "application/activity+json",
          "href" => ""
        }
      ]
    }

    response_json = JSON.parse(response.body)

    assert_equal expected_json, response_json
  end

  test "return content-type is 'application/activity+json'" do
    assert_equal "application/activity+json; charset=utf-8", response.content_type
  end
end
