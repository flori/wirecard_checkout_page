require 'spec_helper'

describe WirecardCheckoutPage::Toolkit::Response do
  let(:success_response) { described_class.new('status=0&orderNumber=4180566') }
  let(:failure_response) { described_class.new('status=1&message=Source+ORDERNUMBER+is+invalid.&errorCode=18159') }

  describe '#success?' do
    it 'returns true for a success response' do
      expect(success_response).to be_success
    end

    it 'returns false for a failure response' do
      expect(failure_response).not_to be_success
    end
  end

  describe '#error_code' do
    it 'returns an empty string for a success response' do
      expect(success_response.error_code).to eq ''
    end

    it 'the correct error code for a failure response' do
      expect(failure_response.error_code).to eq '18159'
    end
  end

  describe '#order_number' do
    it 'returns the correct id for a success response' do
      expect(success_response.order_number).to eq 4180566
    end

    it 'returns nil for a failure response' do
      expect(failure_response.order_number).to eq 0
    end
  end
end
