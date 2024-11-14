class InboxProcessJob < ApplicationJob
  queue_as :default

  def perform(account, json)
    InboxProcessHandler.new.call(account, json)
  end
end
