require 'spec_helper'

describe WirecardCheckoutPage::Toolkit::RecurPayment do

  let(:valid_params) do
    {
      customerId:        'D200001',
      toolkitPassword:   'jcv45z',
      secret:            'B8AKTPWBRMNBV455FG6M2DANE99WU2',
      sourceOrderNumber: 'sourceOrderNumber',
      orderDescription:  'orderDescription',
      amount:            '345',
      currency:          'EUR'
    }
  end

  let(:optional_params) do
    {
      shopId: 'ABC',
      autoDeposit: 'Yes',
      customerStatement: 'customerStatement',
      orderNumber: 'orderNumber',
      orderReference: 'orderReference',
    }
  end

  describe '#call' do
    context 'with missing params' do
      it 'has missing_keys' do
        expected_keys = %w(customerId toolkitPassword secret sourceOrderNumber orderDescription amount currency)
        expect(subject.missing_keys).to eq expected_keys
      end

      it 'raises ValueMissing' do
        expect { subject.call } .to raise_error WirecardCheckoutPage::ValueMissing
      end
    end

    context 'with valid params' do
      subject { described_class.new params: valid_params }

      it 'has no missing_keys' do
        expect(subject.missing_keys).to be_empty
      end
    end
  end


  describe '#fingerprint_keys' do
    it 'has the right fingerprint_keys' do
      expected_keys = %w(
        customerId shopId toolkitPassword secret command language orderNumber sourceOrderNumber
        autoDeposit orderDescription amount currency orderReference customerStatement
      )
      expect(subject.fingerprint_keys).to eq expected_keys
    end
  end

  describe '#required_finger_print_keys' do
    let(:params) { valid_params }
    subject { described_class.new(params: params) }

    context 'with basic params' do
      it 'has the right required_fingerprint_keys' do
        expected_keys = %w(
          customerId toolkitPassword secret command language sourceOrderNumber orderDescription amount currency
        )
        expect(subject.required_fingerprint_keys).to eq expected_keys
      end
    end

    context 'when shopId given' do
      let(:params) { valid_params.merge optional_params }

      it 'has the right required_fingerprint_keys' do
        expected_keys = %w(
          customerId shopId toolkitPassword secret command language orderNumber sourceOrderNumber autoDeposit
          orderDescription amount currency orderReference customerStatement
        )
        expect(subject.required_fingerprint_keys).to eq expected_keys
      end
    end
  end

  describe '#optional_keys' do
    it 'has the right optional_keys' do
      expect(subject.optional_keys).to eq %w(shopId autoDeposit customerStatement orderNumber orderReference)
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
              'sourceOrderNumber' => 'sourceOrderNumber',
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
              'sourceOrderNumber' => 'sourceOrderNumber',
              'orderDescription'  => 'orderDescription',
              'amount'            => '345',
              'currency'          => 'EUR',
              'autoDeposit'       => 'Yes',
              'customerStatement' => 'customerStatement',
              'orderNumber'       => 'orderNumber',
              'orderReference'    => 'orderReference'
            }
          )
      end
    end
  end

  describe '#fingerprinted_request_params' do
    let(:params) { valid_params.merge optional_params }
    subject { described_class.new(params: params).fingerprinted_request_params }
    let(:request_fingerprint_order) do
      'customerId,shopId,toolkitPassword,secret,command,language,orderNumber,sourceOrderNumber,' +
        'autoDeposit,orderDescription,amount,currency,orderReference,customerStatement'
    end

    it 'has the right fingerprinted_request_params' do
      expect(subject).to eq(
          {
            'command'                 => 'recurPayment',
            'language'                => 'en',
            'requestFingerprint'      => 'ce797ca41d044de2a41fd9cf40bf9dc6',
            'requestFingerprintOrder' => request_fingerprint_order,
            'customerId'              => 'D200001',
            'toolkitPassword'         => 'jcv45z',
            'shopId'                  => 'ABC',
            'sourceOrderNumber'       => 'sourceOrderNumber',
            'orderDescription'        => 'orderDescription',
            'amount'                  => '345',
            'currency'                => 'EUR',
            'autoDeposit'             => 'Yes',
            'customerStatement'       => 'customerStatement',
            'orderNumber'             => 'orderNumber',
            'orderReference'          => 'orderReference'
          }
        )
    end
  end

  describe '#fingerprint' do
    context 'with basic params' do
      subject { described_class.new params: valid_params }

      it 'uses the right keys in the right order' do
        expect(subject.required_fingerprint_keys).to eq %w(customerId toolkitPassword secret command
          language sourceOrderNumber orderDescription amount currency)
      end

      it 'has the right fingerprint' do
        str = %w[
          D200001 jcv45z B8AKTPWBRMNBV455FG6M2DANE99WU2 recurPayment en sourceOrderNumber orderDescription 345 EUR
        ] * ''
        expect(subject.fingerprint).to eq Digest::MD5.hexdigest str
      end
    end

    context 'with additional params' do
      let(:params) { valid_params.merge(shopId: 'ABC') }
      subject { described_class.new params: params }

      it 'uses the right keys in the right order' do
        expect(subject.required_fingerprint_keys).to eq %w(customerId shopId toolkitPassword secret
          command language sourceOrderNumber orderDescription amount currency)
      end

      it 'has the right fingerprint' do
        str = %w[
          D200001 ABC jcv45z B8AKTPWBRMNBV455FG6M2DANE99WU2 recurPayment en sourceOrderNumber orderDescription 345 EUR
        ] * ''
        expect(subject.fingerprint).to eq Digest::MD5.hexdigest str
      end
    end
  end

  describe '#headers' do
    it 'gives the right thing' do
      expect(subject.headers).to eq({
        'Host'         => 'secure.wirecard-cee.com',
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Connection'   => 'close',
      })
    end
  end

end
