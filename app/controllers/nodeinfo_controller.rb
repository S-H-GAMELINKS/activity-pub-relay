class NodeinfoController < ApiController
  def show
    render json: {
      "openRegistrations" => true,
      "protocols" => [
        "activitypub"
      ],
      "services" => {
        "inbound" => [],
        "outbound" => []
      },
      "software" => {
        "name" => "activity-pub-relay",
        "version" => "0.7.0",
        "repository" => "https://github.com/S-H-GAMELINKS/activity-pub-relay"
      },
      "usage" => {
        "localPosts" => 0,
        "users" => {
          "total" => 1
        }
      },
      "version" => "2.1",
      "metadata" => {}
    }
  end
end
