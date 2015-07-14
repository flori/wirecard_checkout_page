require 'spec_helper'

describe WirecardCheckoutPage::Gateway do
  let(:credentials) do
    {
      customer_id:      'D200001',
      secret:           'B8AKTPWBRMNBV455FG6M2DANE99WU2',
      toolkit_password: 'jcv45z',
    }
  end
  let(:gateway) { WirecardCheckoutPage::Gateway.new credentials }

  describe '#initialize' do
    it 'stores secret, customerId and init_url if given' do
      gateway = WirecardCheckoutPage::Gateway.new(customer_id: 'foo', secret: 'bar', init_url: 'foobar')
      expect(gateway.customer_id).to eq 'foo'
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
        serviceURL:       'https://foo.com/service',
        successURL:       'https://foo.com/success',
        cancelURL:        'https://foo.com/cancel',
        failureURL:       'https://foo.com/failure',
        confirmURL:       'https://foo.com/confirm',
        orderReference:   '123',
      }
    end

    it 'builds a checksum with the authorization params' do
      expect(WirecardCheckoutPage::RequestChecksum).to receive(:new).
        with(hash_including customerId: 'D200001', secret: 'B8AKTPWBRMNBV455FG6M2DANE99WU2').and_call_original
      gateway.init(valid_params)
    end

    it 'returns a InitResponse with the correct payment url' do
      response = gateway.init(valid_params)
      expect(response).to be_a WirecardCheckoutPage::InitResponse
      payment_url = response.params[:payment_url]
      expect(payment_url).to match %r{https://checkout\.wirecard\.com/page/D200001_DESKTOP/select.php\?SID=.+}
    end
  end

  describe '#recurring_init' do
    let(:valid_params) do
      {
        amount:           '100.00',
        orderDescription: 'order',
        serviceURL:       'https://foo.com/service',
        successURL:       'https://foo.com/success',
        cancelURL:        'https://foo.com/cancel',
        failureURL:       'https://foo.com/failure',
        confirmURL:       'https://foo.com/confirm',
        orderReference:   '123',
      }
    end

    it 'builds a checksum with the authorization params' do
      expect(WirecardCheckoutPage::RequestChecksum).to receive(:new).
        with(hash_including customerId: 'D200001', secret: 'B8AKTPWBRMNBV455FG6M2DANE99WU2').and_call_original
      gateway.init(valid_params)
    end

    it 'returns a InitResponse with the correct payment url' do
      response = gateway.recurring_init(valid_params)
      expect(response).to be_a WirecardCheckoutPage::InitResponse
      payment_url = response.params[:payment_url]
      expect(payment_url).to match %r{https://checkout\.wirecard\.com/page/D200001_DESKTOP/select.php\?SID=.+}
    end
  end

  describe '#recurring_process' do
    let(:valid_params) do
      {
        sourceOrderNumber: '123',
        orderDescription:  'orderDescription',
        amount:            '345',
        currency:          'EUR'
      }
    end

    it 'returns a successful ToolKit::Reponse' do
      response = gateway.recurring_process(valid_params)
      expect(response).to be_a WirecardCheckoutPage::Toolkit::Response
      expect(response).to be_success
    end
  end

  describe '#check_response' do
    it 'builds a checksum with the authorization params' do
      expect(WirecardCheckoutPage::ResponseChecksum).to receive(:new).
        with(
          hash_including('customerId' => 'D200001', 'secret' => 'B8AKTPWBRMNBV455FG6M2DANE99WU2')
      ).and_call_original
      gateway.check_response.valid?
    end

    it 'returns true if the response was valid' do
      allow_any_instance_of(WirecardCheckoutPage::ResponseChecksum).to receive(:valid?).and_return(true)
      expect(gateway.check_response).to be_valid
    end
  end
end
