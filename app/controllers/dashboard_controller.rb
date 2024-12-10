class DashboardController < ApplicationController
  def index
    @rebroadcast_counters = 7.downto(0).map do |num|
      key = num.days.ago.strftime("%Y-%m-%d")
      value = Rails.cache.read(key)

      [ key, value ? value : 0 ]
    end
  end
end
