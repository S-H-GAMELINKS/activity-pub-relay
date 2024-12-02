class DropUsersTable < ActiveRecord::Migration[8.0]
  def up
    remove_index :users, :email_address

    drop_table :users
  end

  def down
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end
