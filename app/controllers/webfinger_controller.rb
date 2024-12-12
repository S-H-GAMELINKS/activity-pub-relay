class WebfingerController < ApiController
  before_action :check_acct

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

  private

  def check_acct
    if params[:resource].blank? || params[:resource] != "acct:relay@#{ENV.fetch("LOCAL_DOMAIN", "www.example.com")}"
      head :not_found
    end
  end
end
