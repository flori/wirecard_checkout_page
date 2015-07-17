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
    let(:stubbed_response) do
      Typhoeus::Response.new(code: 302, body: '', headers: { 'Location' => 'https://example.com/single_init' })
    end
    before { Typhoeus.stub('https://checkout.wirecard.com/page/init.php').and_return(stubbed_response) }

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
      expect(payment_url).to match 'https://example.com/single_init'
    end
  end

  describe '#recurring_init' do
    let(:stubbed_response) do
      Typhoeus::Response.new(code: 302, body: '', headers: { 'Location' => 'https://example.com/recurring_init' })
    end
    before { Typhoeus.stub('https://checkout.wirecard.com/page/init.php').and_return(stubbed_response) }

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
      expect(WirecardCheckoutPage::InitRequest).to receive(:new).and_call_original
      gateway.recurring_init(valid_params)
    end

    it 'returns a InitResponse with the correct payment url' do
      response = gateway.recurring_init(valid_params)
      expect(response).to be_a WirecardCheckoutPage::InitResponse
      payment_url = response.params[:payment_url]
      expect(payment_url).to match 'https://example.com/recurring_init'
    end
  end

  describe '#recurring_process' do
    let(:stubbed_response) { Typhoeus::Response.new(code: 302, body: 'status=0&orderNumber=1') }
    before { Typhoeus.stub('https://checkout.wirecard.com/page/toolkit.php').and_return(stubbed_response) }

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

end
