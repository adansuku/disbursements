# frozen_string_literal: true

# This migration adds a reference to the disbursement table in the orders table.
# It includes a foreign key constraint to ensure referential integrity.

class AddDisbursementToOrder < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :disbursement, type: :uuid, foreign_key: true
  end
end
