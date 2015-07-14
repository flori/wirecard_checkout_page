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
  end

  describe '#body' do
    subject { described_class.new(params: valid_params) }

    it 'returns #fingerprinted_params without secret' do
      expect(subject.body).not_to have_key('secret')
    end
  end

  describe '#call' do
    context 'with missing params' do
      it 'has missing_keys' do
        expect(subject.missing_keys).to eq %w(customerId toolkitPassword)
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
