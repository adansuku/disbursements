# frozen_string_literal: true

class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  # Validations to ensure data integrity
  validates :reference, presence: true, uniqueness: true
  validates :disbursed_at, presence: true
  validates :amount_disbursed, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :amount_fees, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_order_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :disbursement_type, presence: true
  validate :unique_disbursement_for_merchant_and_date

  # Callback to update associated orders when a disbursement is destroyed
  before_destroy :update_orders_disbursements

  # Scope to filter disbursements by year
  scope :by_year, ->(year) { where('extract(year from disbursed_at) = ?', year) }

  # Generates an annual report of disbursements
  def self.annual_disbursement_report
    select("
    EXTRACT(YEAR FROM disbursed_at) as year,
    COUNT(id) as number_of_disbursements,
    SUM(amount_disbursed) as total_amount_disbursed,
    SUM(amount_fees) as total_amount_fees
  ")
      .group(Arel.sql('EXTRACT(YEAR FROM disbursed_at)'))
      .order(Arel.sql('EXTRACT(YEAR FROM disbursed_at)'))
      .map do |data|
      {
        year: data.year.to_i,
        number: data.number_of_disbursements.to_i,
        total_amount_disbursed: data.total_amount_disbursed.to_f.round(2),
        total_amount_fees: data.total_amount_fees.to_f.round(2)
      }
    end
  end

  private

  # Updates associated orders when a disbursement is destroyed
  def update_orders_disbursements
    orders.update_all(disbursement_id: nil, commission_fee: nil)
  end

  # Custom validation to ensure only one disbursement per merchant per date
  def unique_disbursement_for_merchant_and_date
    existing_disbursement = Disbursement.find_by(
      merchant_id:,
      disbursed_at:
    )

    errors.add(:disbursed_at, 'already has a disbursement for this merchant and date') if existing_disbursement.present?
  end
end
