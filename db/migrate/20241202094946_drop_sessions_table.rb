class DropSessionsTable < ActiveRecord::Migration[8.0]
  def up
    remove_foreign_key :sessions, :users
    drop_table :sessions
  end

  def down
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
  end
end
