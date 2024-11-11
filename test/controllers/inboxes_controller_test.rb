require "test_helper"

class InboxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    post "/inbox"
  end

  test "return http accepted" do
    assert_response :accepted
  end
end
