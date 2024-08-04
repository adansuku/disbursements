# frozen_string_literal: true

require 'rails_helper'

RSpec.describe YearlyExportJob, type: :job do
  describe '#perform' do
    let(:yearly_export_service) { instance_double(YearlyExportService) }

    before do
      allow(YearlyExportService).to receive(:new).and_return(yearly_export_service)
      allow(yearly_export_service).to receive(:yearly_data)
    end

    it 'calls yearly_data method of YearlyExportService' do
      expect(yearly_export_service).to receive(:yearly_data)
      described_class.perform_now
    end
  end
end
