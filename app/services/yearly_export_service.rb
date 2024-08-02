# frozen_string_literal: true

require 'csv'

class YearlyExportService
  def yearly_data
    # Combine disbursements and fees data by year
    combined_info_by_year = combine_disbursements_and_fees
    generate_csv_report(combined_info_by_year)

    Rails.logger.info 'Yearly data export completed successfully.'
  rescue StandardError => e
    Rails.logger.error "Oops! Something was wrong, error in YearlyExportService: #{e.message}"
    raise e
  end

  private

  # Combines disbursements and monthly fees data into a single hash by year
  def combine_disbursements_and_fees
    # Fetch annual disbursement report
    disbursements_info = Disbursement.annual_disbursement_report
    # Fetch monthly disbursement report
    monthly_fees_info = MonthlyFee.monthly_disbursement_report

    combined_info_by_year = {}

    # Merge disbursements info into combined data
    merge_data_into_combined_info(disbursements_info, combined_info_by_year)
    # Merge monthly fees info into combined data
    merge_data_into_combined_info(monthly_fees_info, combined_info_by_year)

    combined_info_by_year
  end

  # Merges individual data entries into the combined data hash by year
  def merge_data_into_combined_info(data_info, combined_info_by_year)
    data_info.each do |data|
      year = data[:year]
      combined_info_by_year[year] ||= {}
      combined_info_by_year[year].merge!(data)
    end
  end

  # Generates a CSV report from the combined data and writes it to a file
  def generate_csv_report(combined_info_by_year)
    service = ReportingToolService.new(combined_info_by_year)
    csv_content = service.perform
    File.write('report.csv', csv_content)
  end
end
