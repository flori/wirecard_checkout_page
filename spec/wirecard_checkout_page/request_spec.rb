require 'spec_helper'

class TestRequest < WirecardCheckoutPage::Request

  param :customerId, required: true
  param :shopId
  param :param1,     required: true
  param :secret,     required: true
  param :command,    required: true
  param :language,   required: true

  def initialize(params: {})
    super params: params
    self.command = 'test'
    self.language = 'en'
  end

end

describe WirecardCheckoutPage::Request do
  let(:valid_params) do
    {
      customerId: 'ABC',
      secret:     'geheim',
      param1:     '345'
    }
  end

  describe '#request_params' do
    subject { TestRequest.new params: valid_params }

    it 'has the right request_params' do
      expect(subject.request_params).to eq(
          {
            'command'    => 'test',
            'language'   => 'en',
            'customerId' => 'ABC',
            'param1'     => '345',
          }
        )
    end
  end

  describe '#body' do

    context 'with minimal params' do
      subject { TestRequest.new(params: valid_params) }

      it 'has correct fingerprinted params' do
        expect(subject.body).to  eq(
            {
              'command'                 => 'test',
              'language'                => 'en',
              'customerId'              => 'ABC',
              'param1'                  => '345',
              'requestFingerprint'      => Digest::MD5.hexdigest('ABC''345''geheim''test''en'),
              'requestFingerprintOrder' => 'customerId,param1,secret,command,language',
            }
          )
      end
    end

    context 'with optional params' do
      subject { TestRequest.new(params: valid_params.merge(shopId: 'XYZ')) }

      it 'has correct fingerprinted params' do
        expect(subject.body).to  eq(
            {
              'command'                 => 'test',
              'language'                => 'en',
              'customerId'              => 'ABC',
              'param1'                  => '345',
              'shopId'                  => 'XYZ',
              'requestFingerprint'      => Digest::MD5.hexdigest('ABC''XYZ''345''geheim''test''en'),
              'requestFingerprintOrder' => 'customerId,shopId,param1,secret,command,language',
            }
          )
      end
    end
  end

  describe '#call' do
    it 'raises ValueMissing' do
      expect { TestRequest.new.call } .to raise_error WirecardCheckoutPage::NotImplementedError
    end
  end

end
