class RootController < ApplicationController
  skip_before_action :require_authentication

  def index
    @subscribe_server_domains = SubscribeServer.pluck(:domain)
  end
end
