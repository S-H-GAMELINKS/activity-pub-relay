class Wellknown::NodeinfoController < ApiController
  def show
    render json: {
      "links": [
        {
          "rel": "http://nodeinfo.diaspora.software/ns/schema/2.1",
          "href": "https://#{ENV.fetch("LOCAL_DOMAIN", "www.example.com")}/nodeinfo/2.1"
        }
      ]
    }
  end
end
