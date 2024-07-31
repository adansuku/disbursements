# frozen_string_literal: true

# This migration creates the orders table with a reference to the merchants table.
# It includes columns for merchant_id (UUID) and amount (decimal with precision 10 and scale 2).
# It also adds a foreign key constraint and an index on the merchant_id column.
class Orders < ActiveRecord::Migration[7.1]
  def up
    create_table :orders do |t|
      t.uuid :merchant_id
      t.decimal :amount, precision: 10, scale: 2
      t.decimal :commission_fee, precision: 10, scale: 2

      t.timestamps
    end

    add_foreign_key :orders, :merchants, column: :merchant_id
    add_index :orders, :merchant_id
  end

  def down
    drop_table :orders
  end
end
