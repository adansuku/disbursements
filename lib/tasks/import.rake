# rubocop:disable all

require 'csv'
require 'ruby-progressbar'
require 'activerecord-import'

namespace :import do
  desc 'Import merchants and orders data from CSV files without transaction'
  task data: :environment do
    BATCH_SIZE = 1000

    begin
      merchants_csv_path = Rails.root.join('db', 'data', 'merchants_data.csv')
      orders_csv_path = Rails.root.join('db', 'data', 'orders_data.csv')

      puts 'Starting the process, please wait it could take a while...'

      # Just to be more clear, Track progress
      total_operations = CSV.read(merchants_csv_path, headers: true, col_sep: ';').size +
                         CSV.read(orders_csv_path, headers: true, col_sep: ';').size
      progressbar = ProgressBar.create(total: total_operations, format: '%a %e %P% Processed: %c from %C')

      # Process merchants CSV in batches
      merchants = []
      CSV.foreach(merchants_csv_path, headers: true, col_sep: ';') do |row|
        merchants << Merchant.new(
          id: row['id'],
          reference: row['reference'],
          email: row['email'],
          live_on: row['live_on'],
          disbursement_frequency: row['disbursement_frequency'],
          minimum_monthly_fee: row['minimum_monthly_fee'].to_f
        )

        if merchants.size >= BATCH_SIZE
          Merchant.import(merchants)
          merchants.clear
        end
        progressbar.increment
      end
      Merchant.import(merchants) unless merchants.empty?

      # Process orders CSV in batches
      orders = []
      merchant_ids = Merchant.pluck(:reference, :id).to_h
      CSV.foreach(orders_csv_path, headers: true, col_sep: ';') do |row|
        if merchant_id = merchant_ids[row['merchant_reference']]
          orders << Order.new(
            merchant_id: merchant_id,
            amount: row['amount'].to_f,
            created_at: row['created_at']
          )

          if orders.size >= BATCH_SIZE
            Order.import(orders)
            orders.clear
          end
        else
          puts "Merchant not found for order with ID #{row['id']}. Skipping..."
        end
        progressbar.increment
      end
      Order.import(orders) unless orders.empty?

      puts 'Import completed successfully! Closing the process...'
      exit(0) # Exit with success status
    rescue StandardError => e
      puts "Import failed: #{e.message}"
    end
  end
end
# rubocop:enable all
