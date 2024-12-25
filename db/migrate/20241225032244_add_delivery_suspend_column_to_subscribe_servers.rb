class AddDeliverySuspendColumnToSubscribeServers < ActiveRecord::Migration[8.0]
  def change
    add_column :subscribe_servers, :delivery_suspend, :boolean, null: false, default: false
  end
end
