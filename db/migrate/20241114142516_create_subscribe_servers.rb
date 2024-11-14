class CreateSubscribeServers < ActiveRecord::Migration[8.0]
  def change
    create_table :subscribe_servers do |t|
      t.string :domain, default: "", null: false, index: { unique: true }
      t.string :inbox_url, default: "", null: false

      t.timestamps
    end
  end
end
