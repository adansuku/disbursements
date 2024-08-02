class MonthlyFeeService
  # Initializes the service with a merchant and an optional date
  def initialize(merchant, date = Time.current)
    @merchant = merchant
    @date = date
    raise ArgumentError, 'Merchant cannot be nil' if @merchant.nil?
  end

  # Calculates and creates the monthly fee for the specified date
  def calculate_monthly_fee_from_date
    calculate_and_create_monthly_fee(date)
  end

  # Calculates and creates monthly fees for all months since the merchant became active until the current month
  def all_months_for_merchant
    create_monthly_fees_up_to_current_month
  end

  # Calculates and creates monthly fees for all merchants
  def self.all_months_for_merchants
    Merchant.find_each do |merchant|
      new(merchant).create_monthly_fees_up_to_current_month
    end
  end

  private

  attr_reader :date, :merchant

  # Calculates and creates the monthly fee for a specific date
  def calculate_and_create_monthly_fee(date)
    last_month_date = date.beginning_of_month
    orders_last_month = fetch_orders_for_last_month(last_month_date)
    total_monthly_fee = calculate_monthly_fee(orders_last_month)
    chargeable_amount = calculate_chargeable_amount(total_monthly_fee)
    create_or_find_monthly_fee(date, chargeable_amount)
  end

  # Fetches the orders from the month prior to the given date
  def fetch_orders_for_last_month(last_month_date)
    merchant.orders.where(created_at: last_month_date.all_month)
  end

  # Calculates the chargeable amount based on the minimum monthly fee and the total monthly fee
  def calculate_chargeable_amount(total_monthly_fee)
    [merchant.minimum_monthly_fee - total_monthly_fee, 0].max
  end

  # Creates or finds an existing monthly fee
  def create_or_find_monthly_fee(date, chargeable_amount)
    MonthlyFee.find_or_create_by(
      merchant_id: merchant.id,
      month: date.next_month.beginning_of_month,
      amount: chargeable_amount
    )
  end

  # Creates monthly fees from the merchant's start date up to the current month
  def create_monthly_fees_up_to_current_month
    current_month = Time.current.prev_month.end_of_month
    live_on_month = merchant.live_on.beginning_of_month
    months_between = (live_on_month..current_month).map(&:beginning_of_month).uniq

    months_between.each do |date_item|
      calculate_and_create_monthly_fee(date_item)
    end
  end

  # Calculates the total monthly fee based on the commissions of the orders
  def calculate_monthly_fee(orders)
    orders.sum(&:commission)
  end
end
