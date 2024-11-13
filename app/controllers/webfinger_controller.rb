class WebfingerController < ApplicationController
  def show
    render json: {
      subject: "acct:relay@www.example.com",
      links: [
        {
          rel: "self",
          type: "application/activity+json",
          href: "https://www.example.com/actor"
        }
      ]
    }, content_type: "application/activity+json"
  end

  private

  def acct
      end
end
