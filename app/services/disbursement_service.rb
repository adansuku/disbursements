# frozen_string_literal: true

require 'securerandom'

# DisbursementService handles the creation of disbursements for a merchant
# based on their disbursement frequency (daily or weekly)
class DisbursementService
  # Initializes the service with a merchant
  def initialize(merchant)
    @merchant = merchant
  end

  # Calculates and creates disbursements based on the merchant's disbursement frequency
  # This method acts as a dispatcher, calling the appropriate method based on the frequency
  def calculate_and_create_disbursements
    case merchant.disbursement_frequency
    when 'DAILY'
      daily_disbursement
    when 'WEEKLY'
      weekly_disbursement
    end
  end

  private

  attr_reader :merchant

  # Handles daily disbursements for the merchant
  # It groups pending orders by date and creates a disbursement for each date
  def daily_disbursement
    orders_grouped_by_date = merchant.pending_daily_orders_for_disbursement

    orders_grouped_by_date.each do |date, order|
      create_disbursement_and_process_orders(date, order)
    end
  end

  # Handles weekly disbursements for the merchant
  # It groups pending orders by week and creates a disbursement for each week
  def weekly_disbursement
    orders_grouped_by_week = merchant.pending_weekly_orders_for_disbursement

    orders_grouped_by_week.each do |date, orders|
      create_disbursement_and_process_orders(date, orders)
    end
  end

  # Creates a disbursement and processes orders for a given date
  def create_disbursement_and_process_orders(date, orders)
    DisbursementCalculatorService.new(date, orders, merchant).calculate_and_create_disbursement
  end
end
