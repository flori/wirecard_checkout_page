require 'spec_helper'

describe WirecardCheckoutPage::RequestChecksum do
  let(:secret)      { 'SOMESECRET' }
  let(:customer_id) { 'SOMECUSTOMERID' }
  let(:shop_id)     { 'someshopid' }

  describe '.new' do
    it 'raises a WirecardCheckoutPage::ValueMissing if no values were passed' do
      expect {
        WirecardCheckoutPage::RequestChecksum.new
      }.to raise_error WirecardCheckoutPage::ValueMissing
    end
  end

  describe '#request_parameters' do
    it 'raises a WirecardCheckoutPage::ValueMissing if not all required values were passed' do
      expect {
        WirecardCheckoutPage::RequestChecksum.new(
          fingerprint_keys: %w[foo bar],
        ).request_parameters
      }.to raise_error WirecardCheckoutPage::ValueMissing
    end

    it "doesn't an error if all required values were passed" do
      expect {
        WirecardCheckoutPage::RequestChecksum.new(
          secret:           'foo',
          fingerprint_keys: %w[foo bar],
        ).request_parameters
      }.not_to raise_error
    end

    it 'uses its default parameters and unless they were passed' do
      parameters = WirecardCheckoutPage::RequestChecksum.new(
        secret:           'foo',
        fingerprint_keys: [],
        currency:         'USD'
      ).request_parameters
      expect(parameters).to eq(
        "currency"                => "USD",
        "language"                => "de",
        "paymentType"             => "SELECT",
        "requestFingerprint"      => "d41d8cd98f00b204e9800998ecf8427e",
        "requestFingerprintOrder" => "",
      )
    end

    it "computes a checksum" do
      checksum = WirecardCheckoutPage::RequestChecksum.new(
        secret:           secret,
        fingerprint_keys: WirecardCheckoutPage::RequestChecksum::FINGERPRINT_KEYS + %w[shopId],
        customerId:       customer_id,
        shopId:           shop_id,
        amount:           '6.66',
        orderDescription: 'Kauf einer Seele (billig)',
        successURL:       'http://example.com/success',
        cancelURL:        'http://example.com/cancel',
        failureURL:       'http://example.com/failure',
        serviceURL:       'http://example.com',
        confirmURL:       'http://example.com/confirm',
        orderReference:   '475ae67f248578b92a701',
        transactionIdentifier: 'INITIAL',
      )
      expect(checksum.__send__(:fingerprint)).to eq "b945e47003cc19bfc058ef3be34b42be"
      expect(checksum.request_parameters).to eq(
         "customerId"              => customer_id,
         "shopId"                  => shop_id,
         "paymentType"             => "SELECT",
         "currency"                => "EUR",
         "language"                => "de",
         "amount"                  => "6.66",
         "orderDescription"        => "Kauf einer Seele (billig)",
         "successURL"              => "http://example.com/success",
         "cancelURL"               => "http://example.com/cancel",
         "failureURL"              => "http://example.com/failure",
         "serviceURL"              => "http://example.com",
         "confirmURL"              => "http://example.com/confirm",
         "orderReference"          => "475ae67f248578b92a701",
         "requestFingerprintOrder" => checksum.fingerprint_keys * ',',
         "requestFingerprint"      => "b945e47003cc19bfc058ef3be34b42be",
         "transactionIdentifier"   => "INITIAL"
      )
    end
  end
end
