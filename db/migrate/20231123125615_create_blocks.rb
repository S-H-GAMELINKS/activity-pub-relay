# frozen_string_literal: true

# :nodoc:
class CreateBlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :blocks do |t|
      t.string :domain,  null: false, default: ''

      t.timestamps
    end

    add_index :blocks, :domain, unique: true
  end
end
