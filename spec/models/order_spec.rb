# spec/models/order_spec.rb

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    let(:merchant) { create(:merchant) }
    let(:disbursement) { create :disbursement }

    it 'is valid with valid merchant' do
      order = build(:order, merchant:)
      expect(order).to be_valid
    end

    it 'is not valid without merchant_id' do
      order = build(:order, merchant: nil)
      expect(order).not_to be_valid
    end

    it 'is not valid without amount' do
      order = build(:order, merchant:, amount: nil)
      expect(order).not_to be_valid
    end

    it 'is valid without amount' do
      order = build(:order, merchant:, amount: 30)
      expect(order).to be_valid
    end

    it 'doesn´t delete if containt a disbursement_id' do
      order = build(:order, merchant:, amount: 30, disbursement:)
      order.destroy
      expect(order).to be_valid
    end

    it 'delete if containt a disbursement_id' do
      order = build(:order, merchant:, amount: 30)
      order.destroy
      expect { order.reload }.to raise_error
    end

    it 'should delete disbursement_id and amount if the disbursed is deleeted' do
      order = create(:order, merchant:, amount: 30, disbursement:)
      disbursement.destroy
      order.reload

      expect(order.disbursement).to be_nil
      expect(order.commission_fee).to be_nil
    end
  end

  describe '#commission' do
    let(:merchant) { create(:merchant) }

    context 'when amount is less than 50' do
      it 'returns commission as 1% of the amount' do
        order = build(:order, merchant:, amount: 40)
        expect(order.commission).to eq(0.4)
      end
    end

    context 'when amount is between 50 and 300' do
      it 'returns commission as 0.95% of the amount' do
        order = build(:order, merchant:, amount: 150)
        expect(order.commission).to eq(1.43)
      end
    end

    context 'when amount is greater than 300' do
      it 'returns commission as 0.85% of the amount' do
        order = build(:order, merchant:, amount: 400)
        expect(order.commission).to eq(3.4)
      end
    end
  end
end
