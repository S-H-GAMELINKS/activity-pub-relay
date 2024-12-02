class CreateRodauthOtp < ActiveRecord::Migration[8.0]
  def change
    # Used by the otp feature
    create_table :account_otp_keys, id: false do |t|
      t.integer :id, primary_key: true
      t.foreign_key :accounts, column: :id
      t.string :key, null: false
      t.integer :num_failures, null: false, default: 0
      t.datetime :last_use, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
