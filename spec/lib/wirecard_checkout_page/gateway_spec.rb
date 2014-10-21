require 'spec_helper'

describe WirecardCheckoutPage::Gateway do
  let(:gateway) { WirecardCheckoutPage::Gateway.new(customerId: 'foo', secret: 'bar') }

  describe '#initialize' do
    it 'stores secret, customerId and init_url if given' do
      gateway = WirecardCheckoutPage::Gateway.new(customerId: 'foo', secret: 'bar', init_url: 'foobar')
      expect(gateway.customerId).to eq 'foo'
      expect(gateway.secret).to eq 'bar'
      expect(gateway.init_url).to eq 'foobar'
    end

    it 'takes the default init url if none was given' do
      gateway = WirecardCheckoutPage::Gateway.new
      expect(gateway.init_url).to be_a String
      expect(gateway.init_url).to eq WirecardCheckoutPage::Gateway::DEFAULT_INIT_URL
    end
  end

  describe '#init' do
    let(:valid_params) do
      {
        amount:           '100.00',
        orderDescription: 'order',
        serviceURL:       'service',
        successURL:       'succes',
        cancelURL:        'cancel',
        failureURL:       'failure',
        confirmURL:       'confirm',
        orderReference:   '123',
      }
    end

    it 'builds a checksum with the authorization params' do
      expect(WirecardCheckoutPage::RequestChecksum).to receive(:new).
        with(hash_including customerId: 'foo', secret: 'bar').and_call_original
      gateway.init(valid_params)
    end

    it 'returns a InitResponse with the correct payment url' do
      response = gateway.init(valid_params)
      expect(response).to be_a WirecardCheckoutPage::InitResponse
      expect(response.params).to eq(payment_url: 'payment-url')
    end
  end

  describe '#response_valid?' do
    it 'builds a checksum with the authorization params' do
      expect(WirecardCheckoutPage::ResponseChecksum).to receive(:new).
        with(hash_including customerId: 'foo', secret: 'bar').and_call_original
      gateway.response_valid?
    end

    it 'returns true if the response was valid' do
      allow_any_instance_of(WirecardCheckoutPage::ResponseChecksum).to receive(:valid?).and_return(true)
      expect(gateway.response_valid?).to be true
    end
  end
end
