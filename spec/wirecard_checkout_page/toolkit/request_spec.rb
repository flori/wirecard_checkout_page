require 'spec_helper'

describe WirecardCheckoutPage::Toolkit::Request do
  let(:valid_params) do
    {
      customerId:      'D200001',
      toolkitPassword: 'jcv45z',
      secret:          'B8AKTPWBRMNBV455FG6M2DANE99WU2'
    }
  end

  describe '#fingerprint_keys' do
    it 'has the right fingerprint_keys' do
      expect(subject.fingerprint_keys).to eq %w(customerId shopId toolkitPassword secret command language)
    end
  end

  describe '#required_finger_print_keys' do
    context 'with basic params' do
      it 'has the right required_fingerprint_keys' do
        expect(subject.required_fingerprint_keys).to eq %w(customerId toolkitPassword secret command language)
      end
    end

    context 'when shopId given' do
      subject { described_class.new params: {shopId: '1234'} }
      it 'has the right required_fingerprint_keys' do
        expect(subject.required_fingerprint_keys).to eq %w(customerId shopId toolkitPassword secret command language)
      end
    end
  end

  describe '#optional_keys' do
    it 'has the right optional_keys' do
      expect(subject.optional_keys).to eq %w(shopId)
    end
  end

  describe '#request_params' do
    subject { described_class.new command: 'test', params: valid_params }

    it 'has the right request_params' do
      expect(subject.request_params).to eq(
          {
            'command'         => 'test',
            'language'        => 'en',
            'customerId'      => 'D200001',
            'toolkitPassword' => 'jcv45z',
          }
        )
    end

    it 'has the right fingerprinted_request_params' do
      expect(subject.fingerprinted_request_params).to eq(
          {
            'command'                 => 'test',
            'language'                => 'en',
            'requestFingerprint'      => '406550dd4fa810409d14022264aeecfe',
            'requestFingerprintOrder' => 'customerId,toolkitPassword,secret,command,language',
            'customerId'              => 'D200001',
            'toolkitPassword'         => 'jcv45z',
          }
        )
    end
  end

  describe '#body' do
    subject { described_class.new(params: valid_params) }

    it 'returns #fingerprinted_request_params without secret' do
      expect(subject.body).not_to have_key('secret')
    end
  end

  describe '#call' do
    context 'with missing params' do
      it 'has missing_keys' do
        expect(subject.missing_keys).to eq %w(customerId toolkitPassword secret)
      end

      it 'raises ValueMissing' do
        expect { subject.call } .to raise_error WirecardCheckoutPage::ValueMissing
      end
    end

    context 'with valid params' do
      subject { described_class.new command: 'test', params: valid_params }

      it 'has no missing_keys' do
        expect(subject.missing_keys).to be_empty
      end

      it 'wraps the response in a toolkit a response object' do
        response = subject.call
        expect(response).to be_a WirecardCheckoutPage::Toolkit::Response
      end
    end
  end

  describe '#fingerprint' do
    context 'with basic params' do
      subject { described_class.new command: 'test', params: valid_params }

      it 'uses the right keys in the right order' do
        expect(subject.required_fingerprint_keys).to eq %w(customerId toolkitPassword secret command language)
      end

      it 'has the right fingerprint' do
        str = 'D200001' 'jcv45z' 'B8AKTPWBRMNBV455FG6M2DANE99WU2' 'test' 'en'
        expect(subject.fingerprint).to eq Digest::MD5.hexdigest str
      end
    end

    context 'with additional params' do
      let(:params) { valid_params.merge(shopId: 'ABC') }
      subject { described_class.new command: 'test', params: params }

      it 'uses the right keys in the right order' do
        expect(subject.required_fingerprint_keys).to eq %w(customerId shopId toolkitPassword secret command language)
      end

      it 'has the right fingerprint' do
        str = 'D200001' 'ABC' 'jcv45z' 'B8AKTPWBRMNBV455FG6M2DANE99WU2' 'test' 'en'
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
