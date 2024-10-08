# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  let(:merchant) { create(:merchant) }
  let(:disbursement) { build(:disbursement, merchant:) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      disbursement = build(:disbursement, merchant:)
      expect(disbursement).to be_valid
    end

    it 'is not valid without merchant_id' do
      disbursement = build(:disbursement, merchant: nil)
      expect(disbursement).not_to be_valid
    end

    it 'is not valid without reference' do
      disbursement = build(:disbursement, merchant:, reference: nil)
      expect(disbursement).not_to be_valid
    end

    it 'is not valid without disbursed_at' do
      disbursement = build(:disbursement, merchant:, disbursed_at: nil)
      expect(disbursement).not_to be_valid
    end

    it 'is not valid without amount_disbursed' do
      disbursement = build(:disbursement, merchant:, amount_disbursed: nil)
      expect(disbursement).not_to be_valid
    end

    it 'is not valid without amount_fees' do
      disbursement = build(:disbursement, merchant:, amount_fees: nil)
      expect(disbursement).not_to be_valid
    end

    it 'is not valid without total_order_amount' do
      disbursement = build(:disbursement, merchant:, total_order_amount: nil)
      expect(disbursement).not_to be_valid
    end

    it 'is not valid without disbursement_type' do
      disbursement = build(:disbursement, merchant:, disbursement_type: nil)
      expect(disbursement).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a merchant' do
      expect(disbursement.merchant).to eq(merchant)
    end
  end

  describe 'callbacks' do
    it 'updates orders disbursements after destroy' do
      disbursement = create(:disbursement, merchant:)
      orders = create_list(:order, 3, disbursement:)

      expect { disbursement.destroy }.to change { orders.map(&:reload).pluck(:disbursement_id) }.to([nil, nil, nil])
    end
  end

  describe 'scopes' do
    describe '.by_year' do
      it 'filters disbursements by year' do
        Disbursement.destroy_all
        disbursement2022 = create(:disbursement, disbursed_at: '2022-01-01')
        disbursement2023 = create(:disbursement, disbursed_at: '2023-01-01')

        expect(Disbursement.by_year(2022).reload).to eq([disbursement2022])
        expect(Disbursement.by_year(2023).reload).to eq([disbursement2023])
      end
    end
  end

  describe 'class methods' do
    describe '.annual_disbursement_report' do
      it 'returns annual disbursement report data' do
        Disbursement.destroy_all
        create(:disbursement, disbursed_at: '2022-01-01', amount_disbursed: 100, amount_fees: 5, id: 1)
        create(:disbursement, disbursed_at: '2022-02-01', amount_disbursed: 150, amount_fees: 7.5, id: 2)
        create(:disbursement, disbursed_at: '2023-02-01', amount_disbursed: 50, amount_fees: 7, id: 3)

        report = Disbursement.annual_disbursement_report
        expect(report).to eq([
                               { year: 2022, number: 2, total_amount_disbursed: 250.0, total_amount_fees: 12.5 },
                               { year: 2023, number: 1, total_amount_disbursed: 50.0, total_amount_fees: 7 }
                             ])
      end
    end
  end

  describe '#unique_disbursement_for_merchant_and_date' do
    let(:merchant) { create(:merchant) }
    let(:disbursed_at) { Time.now }

    it 'should add an error if a disbursement already exists for the merchant and date' do
      create(:disbursement, merchant:, disbursed_at:)
      disbursement = build(:disbursement, merchant:, disbursed_at:)
      disbursement.valid?

      expect(disbursement.errors).not_to be_empty
    end

    it 'should not add an error if no disbursement exists for the merchant and date' do
      disbursement = build(:disbursement, merchant:, disbursed_at:)
      disbursement.valid?

      expect(disbursement.errors).to be_empty
    end
  end
end
