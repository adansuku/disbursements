class CreateMerchants < ActiveRecord::Migration[7.0]
  def up
    create_table :merchants, id: :uuid do |t|
      t.string :reference
      t.string :email
      t.date :live_on
      t.string :disbursement_frequency
      t.decimal :minimum_monthly_fee, precision: 10, scale: 2

      t.timestamps
    end
  end

  def down
    drop_table :merchants
  end
end
