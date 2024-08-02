class AddMonthlyFee < ActiveRecord::Migration[7.1]
  def up
    create_table :monthly_fees do |t|
      t.uuid :merchant_id, null: false
      t.date :month
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end
  end

  def down
    drop_table :monthly_fees
  end
end
