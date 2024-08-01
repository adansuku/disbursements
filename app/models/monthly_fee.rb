class MonthlyFee < ApplicationRecord
  belongs_to :merchant

  validates :merchant_id, presence: true
  validates :month, presence: true
  validates :amount, presence: true

  validates :month,
            uniqueness: { scope: :merchant_id,
                          message: 'The Montly fee exists for this Merchant' }
end
