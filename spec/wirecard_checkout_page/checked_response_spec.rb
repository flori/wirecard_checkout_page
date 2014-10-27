require 'spec_helper'

describe WirecardCheckoutPage::CheckedResponse do
  let :checked_response do
    WirecardCheckoutPage::CheckedResponse.new(
      paymentState: 'SUCCESS',
      message:      'It worked!'
    )
  end

  describe '#success?' do
    it 'is not succcessful if invalid' do
      allow(checked_response).to receive(:valid?).and_return(false)
      expect(checked_response).to_not be_success
    end

    it 'is not succcessful if paymentState is not "SUCCESS"' do
      checked_response = WirecardCheckoutPage::CheckedResponse.new(
        paymentState: 'SOMETHING'
      )
      allow(checked_response).to receive(:valid?).and_return(true)
      expect(checked_response).to_not be_success
    end

    it 'is succcessful if valid and paymentState "SUCCESS"' do
      allow(checked_response).to receive(:valid?).and_return(true)
      expect(checked_response).to be_success
    end
  end

  describe '#params' do
    it 'returns the the params' do
      expect(checked_response.params).to eq(
        'message'      => 'It worked!',
        'paymentState' => 'SUCCESS'
      )
    end
  end

  describe '#message' do
    it 'returns the message' do
      expect(checked_response.message).to eq 'It worked!'
    end
  end
end
