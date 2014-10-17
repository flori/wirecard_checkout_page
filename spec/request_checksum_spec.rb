require 'spec_helper'

describe WirecardCheckoutPage::RequestChecksum do
  let :secret do
    'SOMESECRET'
  end

  let :customer_id do
    'SOMECUSTOMERID'
  end

  let :shop_id do
    'someshopid'
  end

  it "raises a WirecardCheckoutPage::ChecksumCreationFailed if no values were passed" do
    expect {
      WirecardCheckoutPage::RequestChecksum.new.fingerprint
    }.to raise_error WirecardCheckoutPage::ValueMissing
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
    )
    expect(checksum.fingerprint).to eq "10feda94a5db9f3e2fc7439d3c4c228b"
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
       "requestFingerprint"      => "10feda94a5db9f3e2fc7439d3c4c228b"
    )
    expect(checksum.request_url).to be_a URI
    expect(checksum.request_url.to_s).to be_start_with(
      'https://checkout.wirecard.com/page/init.php?amount=6.66'
    )
  end
end
