require 'spec_helper'

describe WirecardCheckoutPage::Toolkit::RecurPayment do

  let(:valid_params) do
    {
      customerId:        'D200001',
      toolkitPassword:   'jcv45z',
      secret:            'B8AKTPWBRMNBV455FG6M2DANE99WU2',
      sourceOrderNumber: '987654',
      orderDescription:  'orderDescription',
      amount:            '345',
      currency:          'EUR'
    }
  end

  let(:optional_params) do
    {
      shopId:            'ABC',
      autoDeposit:       'Yes',
      customerStatement: 'customerStatement',
      orderNumber:       '54321',
      orderReference:    'orderReference',
    }
  end

  describe '#call' do
    context 'with missing params' do
      it 'raises ValueMissing' do
        expect { subject.call } .to raise_error WirecardCheckoutPage::ValueMissing
      end
    end

    context 'with valid params' do
      subject { described_class.new params: valid_params }

      let(:stubbed_response) { Typhoeus::Response.new(code: 200, body: 'status=0&orderNumber=1') }
      before { Typhoeus.stub('https://checkout.wirecard.com/page/toolkit.php').and_return(stubbed_response) }

      it 'makes the call to Wirecard' do
        response = subject.call
        expect(response).to be_a WirecardCheckoutPage::Toolkit::Response
        expect(response).to be_success
      end
    end
  end

  describe '#request_params' do
    let(:params) { valid_params }
    subject { described_class.new(params: params).request_params }

    context 'minimal params' do
      it 'has the right request_params' do
        expect(subject).to eq(
            {
              'command'           => 'recurPayment',
              'language'          => 'en',
              'customerId'        => 'D200001',
              'toolkitPassword'   => 'jcv45z',
              'sourceOrderNumber' => '987654',
              'orderDescription'  => 'orderDescription',
              'amount'            => '345',
              'currency'          => 'EUR'
            }
          )
      end
    end

    context 'with optional params' do
      let(:params) { valid_params.merge optional_params }

      it 'has the right request_params' do
        expect(subject).to eq(
            {
              'command'           => 'recurPayment',
              'language'          => 'en',
              'customerId'        => 'D200001',
              'toolkitPassword'   => 'jcv45z',
              'shopId'            => 'ABC',
              'sourceOrderNumber' => '987654',
              'orderDescription'  => 'orderDescription',
              'amount'            => '345',
              'currency'          => 'EUR',
              'autoDeposit'       => 'Yes',
              'customerStatement' => 'customerStatement',
              'orderNumber'       => '54321',
              'orderReference'    => 'orderReference'
            }
          )
      end
    end
  end

  describe '#body' do
    let(:params) { valid_params.merge optional_params }
    subject      { described_class.new(params: params).body }
    let(:request_fingerprint_order) do
      'customerId,shopId,toolkitPassword,secret,command,language,orderNumber,sourceOrderNumber,' +
        'autoDeposit,orderDescription,amount,currency,orderReference,customerStatement'
    end

    it 'has the right fingerprinted_request_params' do
      expect(subject).to eq(
          {
            'command'                 => 'recurPayment',
            'language'                => 'en',
            'requestFingerprint'      => '9a95827c960afabc09cb786872f78ec2',
            'requestFingerprintOrder' => request_fingerprint_order,
            'customerId'              => 'D200001',
            'toolkitPassword'         => 'jcv45z',
            'shopId'                  => 'ABC',
            'sourceOrderNumber'       => '987654',
            'orderDescription'        => 'orderDescription',
            'amount'                  => '345',
            'currency'                => 'EUR',
            'autoDeposit'             => 'Yes',
            'customerStatement'       => 'customerStatement',
            'orderNumber'             => '54321',
            'orderReference'          => 'orderReference'
          }
        )
    end
  end

end
