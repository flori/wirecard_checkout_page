require 'spec_helper'

class ToolkitTestRequest < WirecardCheckoutPage::Toolkit::Request
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

describe WirecardCheckoutPage::Toolkit::Request do
  let(:valid_params) do
    {
      customerId: 'D200001',
      secret:     'B8AKTPWBRMNBV455FG6M2DANE99WU2',
      param1:     '345'
    }
  end

  describe '#request_params' do
    subject { ToolkitTestRequest.new params: valid_params }

    it 'has the right request_params' do
      expect(subject.request_params).to eq(
          {
            'command'    => 'test',
            'language'   => 'en',
            'customerId' => 'D200001',
            'param1'     => '345',
          }
        )
    end
  end

  describe '#body' do
    subject { ToolkitTestRequest.new(params: valid_params) }

    it 'returns #fingerprinted_params without secret' do
      expect(subject.body).not_to have_key('secret')
    end
  end

  describe '#call' do
    context 'with missing params' do
      it 'raises ValueMissing' do
        expect { ToolkitTestRequest.new.call } .to raise_error WirecardCheckoutPage::ValueMissing
      end
    end

    context 'with valid params' do
      subject { ToolkitTestRequest.new params: valid_params }

      let(:stubbed_response) { Typhoeus::Response.new(code: 200, body: '') }
      before { Typhoeus.stub('https://checkout.wirecard.com/page/toolkit.php').and_return(stubbed_response) }

      it 'wraps the response in a toolkit a response object' do
        expect(subject.call).to be_a WirecardCheckoutPage::Toolkit::Response
      end
    end
  end

  describe '#headers' do
    it 'gives the right thing' do
      expect(ToolkitTestRequest.new.headers).to eq({
        'Host'         => 'secure.wirecard-cee.com',
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Connection'   => 'close',
      })
    end
  end

end
