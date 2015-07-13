require 'spec_helper'

describe WirecardCheckoutPage::Toolkit::Request do

  let(:valid_params) do
    {
      customerId:      '123',
      toolkitPassword: '321',
      secret:          'geheim'
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
            'customerId'      => '123',
            'toolkitPassword' => '321',
            'secret'          => 'geheim'
          }
        )
    end

    it 'has the right fingerprinted_request_params' do
      expect(subject.fingerprinted_request_params).to eq(
          {
            'command'                 => 'test',
            'language'                => 'en',
            'requestFingerprint'      => '28eef8ae3954ce6830584252588e07a8',
            'requestFingerprintOrder' => 'customerId,toolkitPassword,secret,command,language',
            'customerId'              => '123',
            'toolkitPassword'         => '321',
            'secret'                  => 'geheim'
          }
        )
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

      it 'makes the post request' do
        allow(Typhoeus).to receive(:post)
        expect(Typhoeus).to receive(:post)
        subject.call
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
        str = '123321geheimtesten'
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
        str = '123ABC321geheimtesten'
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
