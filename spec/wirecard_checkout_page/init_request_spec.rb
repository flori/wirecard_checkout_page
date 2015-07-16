require 'spec_helper'

describe WirecardCheckoutPage::InitRequest do
  let(:valid_params) do
    {
      customerId:            'D200001',
      secret:                'B8AKTPWBRMNBV455FG6M2DANE99WU2',
      amount:                '100.00',
      currency:              'EUR',
      orderDescription:      'order',
      serviceUrl:            'https://foo.com/service',
      successUrl:            'https://foo.com/success',
      cancelUrl:             'https://foo.com/cancel',
      failureUrl:            'https://foo.com/failure',
      confirmUrl:            'https://foo.com/confirm',
      orderReference:        '123',
      language:              'de',
      paymentType:           'SELECT',
    }
  end

  describe '#body' do
    context 'with standard params' do
      it 'has the right fingerprint' do
        request = described_class.new params: valid_params
        expected_request_fingerprint_order = 'secret,customerId,language,paymentType,amount,currency,orderDescription,successUrl,cancelUrl,failureUrl,serviceUrl,confirmUrl,orderReference,transactionIdentifier,requestFingerprintOrder'
        expect(request.body['requestFingerprintOrder']).to eq expected_request_fingerprint_order
        expect(request.body['requestFingerprint']).to eq Digest::MD5.hexdigest(
              'B8AKTPWBRMNBV455FG6M2DANE99WU2''D200001''de''SELECT''100.00''EUR''order''https://foo.com/success''https://foo.com/cancel''https://foo.com/failure''https://foo.com/service''https://foo.com/confirm''123''SINGLE'"#{expected_request_fingerprint_order}"
            )
      end
    end

    context 'with recurring init' do
      it 'has the right fingerprint' do
        request = described_class.new params: valid_params.merge(transactionIdentifier: 'INITIAL')
        expected_request_fingerprint_order = 'secret,customerId,language,paymentType,amount,currency,orderDescription,successUrl,cancelUrl,failureUrl,serviceUrl,confirmUrl,orderReference,transactionIdentifier,requestFingerprintOrder'
        expect(request.body['requestFingerprintOrder']).to eq expected_request_fingerprint_order
        expect(request.body['requestFingerprint']).to eq Digest::MD5.hexdigest(
              'B8AKTPWBRMNBV455FG6M2DANE99WU2''D200001''de''SELECT''100.00''EUR''order''https://foo.com/success''https://foo.com/cancel''https://foo.com/failure''https://foo.com/service''https://foo.com/confirm''123''INITIAL'"#{expected_request_fingerprint_order}"
            )
      end
    end
  end

  context 'performing a request' do
    let(:stubbed_response) do
      Typhoeus::Response.new(code: 302, body: '', headers: { 'Location' => 'https://example.com/single_init' })
    end
    before { Typhoeus.stub('https://checkout.wirecard.com/page/init.php').and_return(stubbed_response) }

    it 'makes a successful request' do
      request = described_class.new params: valid_params

      response = request.call
      expect(response).to be_a WirecardCheckoutPage::InitResponse
      expect(response).to be_success
      payment_url = response.params[:payment_url]
      expect(payment_url).to match 'https://example.com/single_init'
    end
  end
end
