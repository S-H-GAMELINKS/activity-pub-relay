class RootController < ApplicationController
  def index
    @subscribe_server_domains = SubscribeServer.pluck(:domain)
  end
end
