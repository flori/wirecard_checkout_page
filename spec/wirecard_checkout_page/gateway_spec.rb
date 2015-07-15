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
      gateway = WirecardCheckoutPage::Gateway.new(
        customer_id: 'foo',
        secret: 'bar',
        toolkit_password: '123'
      )
      expect(gateway.customer_id).to eq 'foo'
      expect(gateway.secret).to eq 'bar'
      expect(gateway.toolkit_password).to eq '123'
    end
  end

  describe '#init' do
    let(:valid_params) do
      {
        amount:           '100.00',
        currency:         'EUR',
        orderDescription: 'order',
        serviceUrl:       'https://foo.com/service',
        successUrl:       'https://foo.com/success',
        cancelUrl:        'https://foo.com/cancel',
        failureUrl:       'https://foo.com/failure',
        confirmUrl:       'https://foo.com/confirm',
        orderReference:   '123',
        language:         'de',
        paymentType:      'SELECT',
      }
    end

    it 'builds' do
      expect(WirecardCheckoutPage::InitRequest).to receive(:new).and_call_original
      gateway.init(valid_params)
    end

    it 'returns a InitResponse with the correct payment url' do
      gateway = WirecardCheckoutPage::Gateway.new(
        customer_id: 'D200001',
        secret: 'B8AKTPWBRMNBV455FG6M2DANE99WU2',
      )
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
        currency:         'EUR',
        paymentType:      'SELECT',
        orderDescription: 'order',
        serviceUrl:       'https://foo.com/service',
        successUrl:       'https://foo.com/success',
        cancelUrl:        'https://foo.com/cancel',
        failureUrl:       'https://foo.com/failure',
        confirmUrl:       'https://foo.com/confirm',
        orderReference:   '123',
        language:         'de',
      }
    end

    it 'builds a checksum with the authorization params' do
      expect(WirecardCheckoutPage::RecurringInitRequest).to receive(:new).and_call_original
      gateway.recurring_init(valid_params)
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
