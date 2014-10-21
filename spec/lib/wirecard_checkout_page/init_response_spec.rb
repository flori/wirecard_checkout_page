require 'spec_helper'

describe WirecardCheckoutPage::InitResponse do

  let(:success_response) do
    http_response = double(headers: { 'Location' => 'payment-url' }, body: '')
    WirecardCheckoutPage::InitResponse.new(http_response)
  end

  let(:failure_response) do
    http_response = double(headers: {}, body: 'Error message')
    WirecardCheckoutPage::InitResponse.new(http_response)
  end

  describe '#params' do
    it 'extracts the payment_url from the headers' do
      expect(success_response.params).to eq({ payment_url: 'payment-url' })
    end

    it 'returns nil as payment_url on error' do
      expect(failure_response.params).to eq({ payment_url: nil })
    end
  end

  describe '#success?' do
    it 'returns true if payment_url is present' do
      expect(success_response).to be_success
    end

    it 'returns false if payment_url is blank' do
      expect(failure_response).not_to be_success
    end
  end

  describe '#message' do
    it 'returns the response body' do
      expect(success_response.message).to eq ''
      expect(failure_response.message).to eq 'Error message'
    end
  end

end
