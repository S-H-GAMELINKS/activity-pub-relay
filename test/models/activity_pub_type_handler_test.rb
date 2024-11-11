require "test_helper"

class ActivityPubTypeHandlerTest < ActiveSupport::TestCase
  test "json['type'] == 'Follow'" do
    json = {
      "type" => "Follow"
    }

    result = ActivityPubTypeHandler.new(json).call

    assert_equal :follow, result
  end

  test "json['type'] != 'Follow'" do
    json = {
      "type" => "Create"
    }

    result = ActivityPubTypeHandler.new(json).call

    assert_equal :none, result
  end
end
