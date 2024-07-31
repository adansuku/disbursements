# frozen_string_literal: true

# Disbursement model represents a disbursement to a merchant.
# Each disbursement belongs to a specific merchant and has many orders.
class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates :reference, presence: true, uniqueness: true
  validates :disbursed_at, presence: true
  validates :amount_disbursed, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :amount_fees, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_order_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :disbursement_type, presence: true
  validate :unique_disbursement_for_merchant_and_date

  before_destroy :update_orders_disbursements

  scope :by_year, ->(year) { where('extract(year from disbursed_at) = ?', year) }

  private

  def update_orders_disbursements
    orders.update_all(disbursement_id: nil, commission_fee: nil)
  end

  def unique_disbursement_for_merchant_and_date
    existing_disbursement = Disbursement.find_by(
      merchant_id:,
      disbursed_at:
    )

    debugger

    errors.add(:disbursed_at, 'already has a disbursement for this merchant and date') if existing_disbursement.present?
  end
end
