class WebfingerController < ApiController
  def show
    render json: {
      subject: "acct:relay@#{ENV.fetch("LOCAL_DOMAIN", "www.example.com")}",
      links: [
        {
          rel: "self",
          type: "application/activity+json",
          href: "https://#{ENV.fetch("LOCAL_DOMAIN", "www.example.com")}/actor"
        }
      ]
    }, content_type: "application/activity+json"
  end
end
