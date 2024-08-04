# frozen_string_literal: true

class DisbursementWorker
  include Sidekiq::Worker

  def perform(merchant_id)
    Rails.logger.info "Starting disbursement calculation for merchant_id: #{merchant_id}"

    merchant = Merchant.find(merchant_id)
    Rails.logger.info "Found merchant: #{merchant.inspect}"

    begin
      DisbursementService.new(merchant).calculate_and_create_disbursements
      Rails.logger.info "Successfully created disbursements for merchant_id: #{merchant_id}"
    rescue StandardError => e
      Rails.logger.error "Failed to create disbursements for merchant_id: #{merchant_id}, error: #{e.message}"
      raise e
    end
  end
end
