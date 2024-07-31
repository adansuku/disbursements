# frozen_string_literal: true

# This migration creates the disbursements table.
# It includes columns for reference (string), disbursed_at (date), merchant_id (UUID),
# amount_disbursed (decimal with precision 10 and scale 2), amount_fees (decimal with precision 10 and scale 2),
# total_order_amount (decimal with precision 10 and scale 2), and disbursement_type (string).
class CreateDisbursements < ActiveRecord::Migration[7.0]
  def up
    create_table :disbursements, id: :uuid do |t| # Ensure id is UUID
      t.string :reference, null: false
      t.date :disbursed_at, null: false
      t.uuid :merchant_id, null: false # Change to UUID
      t.decimal :amount_disbursed, precision: 10, scale: 2
      t.decimal :amount_fees, precision: 10, scale: 2
      t.decimal :total_order_amount, precision: 10, scale: 2
      t.string :disbursement_type

      t.timestamps
    end

    add_foreign_key :disbursements, :merchants, column: :merchant_id
    add_index :disbursements, :reference, unique: true
  end

  def down
    drop_table :disbursements
  end
end
