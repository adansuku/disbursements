# frozen_string_literal: true

# DisbursementCalculatorService handles the calculation and creation of disbursements for a merchant
class DisbursementCalculatorService
  # Initializes the service with the necessary data
  def initialize(date, orders, merchant)
    @date = date
    @orders = orders.reject { |order| order.disbursement_id.present? }
    @merchant = merchant
  end

  # Calculates and creates a disbursement for the given orders
  # This method is wrapped in a transaction to ensure data integrity
  def calculate_and_create_disbursement
    ActiveRecord::Base.transaction do
      return if merchant.merchant_disbursement_exists_for_period?(date) || orders.empty?

      disbursement = build_disbursement
      process_orders(disbursement)
      save_disbursement(disbursement)
    end
  rescue StandardError => e
    Rails.logger.error("Error during disbursement calculation: #{e.message}")
    raise ActiveRecord::Rollback
  end

  private

  attr_reader :date, :merchant, :orders

  # Builds a new Disbursement object with calculated values
  def build_disbursement
    total_order_amount = orders.sum { |order| BigDecimal(order.amount.to_s) }
    total_commission = orders.sum { |order| BigDecimal(order.commission.to_s) }
    disbursed_amount = total_order_amount - total_commission

    Disbursement.new(
      reference: generate_unique_reference,
      merchant_id: merchant.id,
      total_order_amount: total_order_amount.round(2).to_f,
      amount_disbursed: disbursed_amount.round(2).to_f,
      amount_fees: total_commission.round(2).to_f,
      disbursement_type: merchant.disbursement_frequency,
      disbursed_at: date
    )
  end

  # Processes each order, updating it with the new disbursement
  # Also calculates monthly fees if necessary
  def process_orders(disbursement)
    orders.each do |order|
      order.update(disbursement:, commission_fee: order.commission)
      MonthlyFeeService.new(merchant, order.created_at).calculate_monthly_fee_from_date if order.first_order_of_month?
    end
  end

  # Saves the disbursement to the database
  def save_disbursement(disbursement)
    disbursement.save
  end

  # Generates a unique reference for the disbursement
  def generate_unique_reference
    "#{merchant.id}-#{date.strftime('%Y%m%d')}-#{SecureRandom.hex(4)}"
  end
end
