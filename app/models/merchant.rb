# frozen_string_literal: true

# Merchant model represents a merchant in the system.
# A merchant can have many orders, disbursements, and monthly fees.
class Merchant < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :disbursements
  has_many :monthly_fees, dependent: :destroy

  # Validations to ensure data integrity
  validates :email, presence: true
  validates :disbursement_frequency, presence: true
  validates :minimum_monthly_fee, presence: true
  validates :reference, presence: true

  # Retrieves pending daily orders for disbursement
  def pending_daily_orders_for_disbursement
    orders.where(disbursement: nil).where.not('DATE(created_at) = ?', Date.today).group_by do |order|
      order.created_at.to_date
    end
  end

  # Retrieves pending weekly orders for disbursement
  def pending_weekly_orders_for_disbursement
    start_date = live_on.beginning_of_day
    orders_grouped_by_week = {}
    while start_date < Date.today
      orders = get_orders_within_a_week(start_date)
      orders_grouped_by_week[start_date.to_date] = orders if orders.present?
      start_date += 7.days
    end
    orders_grouped_by_week
  end

  # Checks if a disbursement exists for the merchant on a specific date
  def merchant_disbursement_exists_for_period?(date)
    existing_disbursement = Disbursement.find_by(
      merchant_id: id,
      disbursed_at: date
    )

    existing_disbursement.present?
  end

  private

  # Retrieves orders within a week starting from a given date
  def get_orders_within_a_week(start_date)
    end_date = start_date.end_of_day + 6.days

    orders_within_week = orders.where(created_at: start_date..end_date, disbursement: nil)

    orders_within_week if (end_date <= Date.today) && orders_within_week.present?
  end
end
