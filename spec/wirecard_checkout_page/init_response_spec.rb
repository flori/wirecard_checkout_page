require 'spec_helper'

describe WirecardCheckoutPage::InitResponse do
  let(:success_response) do
    described_class.from_typhoeus_response(Typhoeus::Response.new(code: 302, body: '', headers: { 'Location' => 'https://foo.com/bar' }))
  end

  describe '#to_s' do
    it 'returns the response body' do
      expect(success_response.to_s).to eq success_response.body
    end
  end
end
