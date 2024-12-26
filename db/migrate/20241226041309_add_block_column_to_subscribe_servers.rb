class AddBlockColumnToSubscribeServers < ActiveRecord::Migration[8.0]
  def change
    add_column :subscribe_servers, :domain_block, :boolean, null: false, default: false
  end
end
