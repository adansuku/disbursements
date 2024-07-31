class Orders < ActiveRecord::Migration[7.1]
  def up
    create_table :orders do |t|
      t.uuid :merchant_id
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end

    add_foreign_key :orders, :merchants, column: :merchant_id
    add_index :orders, :merchant_id
  end

  def down
    drop_table :orders
  end
end
