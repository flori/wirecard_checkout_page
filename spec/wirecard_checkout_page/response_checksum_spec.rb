require 'spec_helper'
require 'wirecard_checkout_page'

describe WirecardCheckoutPage::ResponseChecksum do
  let :secret do
    'SOMESECRET'
  end

  let :customer_id do
    'SOMECUSTOMERID'
  end

  let :shop_id do
    'someshopid'
  end

  it "recognizes a correct response" do
    response_params = {
      secret:                  secret,
      fingerprint_keys:        WirecardCheckoutPage::RequestChecksum::FINGERPRINT_KEYS + %w[shopId],
      customerId:              customer_id,
      shopId:                  shop_id,
      "amount"                 => "28.95",
      "currency"               => "EUR",
      "paymentType"            => "CCARD",
      "financialInstitution"   => "MC",
      "language"               => "de",
      "orderNumber"            => "7739491",
      "paymentState"           => "SUCCESS",
      "utf8"                   => "&#10003;",
      "authenticity_token"     => "bnz1fHxcCYD9jdPiNIEl7yJExRetWWAOQPopmjYksFc=",
      "commit"                 => "Bezahlen",
      "authenticated"          => "No",
      "anonymousPan"           => "0002",
      "expiry"                 => "01/2013",
      "cardholder"             => "Foorian Bar",
      "maskedPan"              => "950000******0002",
      "gatewayReferenceNumber" => "DGW_7739491_RN",
      "gatewayContractNumber"  => "DemoContractNumber123",
      "responseFingerprintOrder"=>"amount,currency,paymentType,"\
        "financialInstitution,language,orderNumber,paymentState,utf8,"\
        "authenticity_token,commit,authenticated,anonymousPan,expiry,"\
        "cardholder,maskedPan,gatewayReferenceNumber,gatewayContractNumber,"\
        "secret,responseFingerprintOrder",
      "responseFingerprint" => "8a1319b4a097d5a9157f479b11e8f5ae",
      "challenge_offer_id"  => "0dd916e49abd1935c2dc084bae2a57b8"
    }
    checksum = WirecardCheckoutPage::ResponseChecksum.new(response_params)
    checksum.valid?
    expect(checksum.computed_fingerprint).to eq '8a1319b4a097d5a9157f479b11e8f5ae'
    expect(checksum).to be_valid
  end

  it "fails check on an incorrect response" do
    response_params = {
      secret:                  secret,
      fingerprint_keys:        WirecardCheckoutPage::RequestChecksum::FINGERPRINT_KEYS + %w[shopId],
      customerId:              customer_id,
      shopId:                  shop_id,
      "amount"                 => "28.95",
      "currency"               => "EUR",
      "paymentType"            => "CCARD",
      "financialInstitution"   => "MC",
      "language"               => "de",
      "orderNumber"            => "7739491",
      "paymentState"           => "SUCCESS",
      "utf8"                   => "&#10003;",
      "authenticity_token"     => "bnz1fHxcCYD9jdPiNIEl7yJExRetWWAOQPopmjYksFc=",
      "commit"                 => "Bezahlen",
      "authenticated"          => "No",
      "anonymousPan"           => "0002",
      "expiry"                 => "01/2013",
      "cardholder"             => "Foorian Bar",
      "maskedPan"              => "950000******0002",
      "gatewayReferenceNumber" => "DGW_7739491_RN",
      "gatewayContractNumber"  => "DemoContractNumber123",
      "responseFingerprintOrder"=>"amount,currency,paymentType,"\
        "financialInstitution,language,orderNumber,paymentState,utf8,"\
        "authenticity_token,commit,authenticated,anonymousPan,expiry,"\
        "cardholder,maskedPan,gatewayReferenceNumber,gatewayContractNumber,"\
        "secret,responseFingerprintOrder",
      "responseFingerprint" => "666c9c80495703dabfc08434d2e99af0",
      "challenge_offer_id"  => "0dd916e49abd1935c2dc084bae2a57b8"
    }
    expect(WirecardCheckoutPage::ResponseChecksum.new(response_params)).
      to_not be_valid
  end

  it "fails check on a response with missing keys" do
    response_params = {
      secret:                  secret,
      fingerprint_keys:        WirecardCheckoutPage::RequestChecksum::FINGERPRINT_KEYS + %w[shopId],
      customerId:              customer_id,
      shopId:                  shop_id,
      "currency"               => "EUR",
      "paymentType"            => "CCARD",
      "financialInstitution"   => "MC",
      "language"               => "de",
      "orderNumber"            => "7739491",
      "paymentState"           => "SUCCESS",
      "utf8"                   => "&#10003;",
      "authenticity_token"     => "bnz1fHxcCYD9jdPiNIEl7yJExRetWWAOQPopmjYksFc=",
      "commit"                 => "Bezahlen",
      "authenticated"          => "No",
      "anonymousPan"           => "0002",
      "expiry"                 => "01/2013",
      "cardholder"             => "Foorian Bar",
      "maskedPan"              => "950000******0002",
      "gatewayReferenceNumber" => "DGW_7739491_RN",
      "gatewayContractNumber"  => "DemoContractNumber123",
      "responseFingerprintOrder"=>"amount,currency,paymentType,"\
        "financialInstitution,language,orderNumber,paymentState,utf8,"\
        "authenticity_token,commit,authenticated,anonymousPan,expiry,"\
        "cardholder,maskedPan,gatewayReferenceNumber,gatewayContractNumber,"\
        "secret,responseFingerprintOrder",
      "responseFingerprint" => "666c9c80495703dabfc08434d2e99af0",
      "challenge_offer_id"  => "0dd916e49abd1935c2dc084bae2a57b8"
    }
    checksum = WirecardCheckoutPage::ResponseChecksum.new(response_params)
    expect(checksum).to_not be_valid
    expect(checksum).to be_missing_keys
    expect(checksum.missing_keys?).to eq %w[amount]
  end

  it "fails check in an empty response" do
    expect(WirecardCheckoutPage::ResponseChecksum.new(secret: secret)).to_not be_valid
  end
end
