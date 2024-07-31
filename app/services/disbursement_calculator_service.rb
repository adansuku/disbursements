# frozen_string_literal: true

class DisbursementCalculatorService
  def initialize(date, orders, merchant)
    @date = date
    @orders = orders.reject { |order| order.disbursement_id.present? }
    @merchant = merchant
  end

  def calculate_and_create_disbursement
    ActiveRecord::Base.transaction do
      return if merchant.merchant_disbursement_exists_for_period?(date) || pending_orders.empty?

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

  def pending_orders
    @pending_orders ||= merchant.orders.unprocessed
  end

  def build_disbursement
    total_order_amount = orders.sum(&:amount)
    total_commission = orders.sum(&:commission)
    disbursed_amount = total_order_amount - total_commission

    Disbursement.new(
      reference: generate_unique_reference,
      merchant_id: merchant.id,
      total_order_amount:,
      amount_disbursed: disbursed_amount,
      amount_fees: total_commission,
      disbursement_type: merchant.disbursement_frequency,
      disbursed_at: date
    )
  end

  def process_orders(disbursement)
    pending_orders.each do |order|
      next if order.disbursement

      order.update(disbursement:, commission_fee: order.commission)
    end
  end

  def save_disbursement(disbursement)
    disbursement.save
  end

  def generate_unique_reference
    "#{merchant.id}-#{date.strftime('%Y%m%d')}-#{SecureRandom.hex(4)}"
  end
end
