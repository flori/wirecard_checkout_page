require 'spec_helper'
require 'wirecard_checkout_page'

describe WirecardCheckoutPage::ResponseChecksum do
  describe '#valid?' do
    context 'with valid parameters' do
      it 'is valid' do
        fingerprint_order           = 'amount,currency,paymentType,financialInstitution,language,orderNumber,paymentState,authenticated,anonymousPan,expiry,maskedPan,gatewayReferenceNumber,gatewayContractNumber,secret,responseFingerprintOrder'
        expected_fingerprint_string = '50.00''EUR''CCARD''Visa''de''8300664''SUCCESS''No''1122''06/2018''405911******1122''C101361143697423285286''000000316159CED9''SECRET'"#{fingerprint_order}"

        params = {
          secret:                    'SECRET',
          'amount'                   => '50.00',
          'currency'                 => 'EUR',
          'paymentType'              => 'CCARD',
          'financialInstitution'     => 'Visa',
          'language'                 => 'de',
          'orderNumber'              => '8300664',
          'paymentState'             => 'SUCCESS',
          'authenticated'            => 'No',
          'anonymousPan'             => '1122',
          'expiry'                   => '06/2018',
          'maskedPan'                => '405911******1122',
          'gatewayReferenceNumber'   => 'C101361143697423285286',
          'gatewayContractNumber'    => '000000316159CED9',
          'responseFingerprintOrder' => fingerprint_order,
          'responseFingerprint'      => 'd1e7ecba3980ca2da4954b9d154c1e1e',
        }
        checksum = described_class.new(params)
        expect(checksum).to be_valid
      end
    end

    context 'with invalid parameters' do
      it 'is not valid' do
        fingerprint_order           = 'amount,currency,paymentType,financialInstitution,language,orderNumber,paymentState,authenticated,anonymousPan,expiry,maskedPan,gatewayReferenceNumber,gatewayContractNumber,secret,responseFingerprintOrder'
        expected_fingerprint_string = '50.00''EUR''CCARD''Visa''de''8300664''SUCCESS''No''1122''06/2018''405911******1122''C101361143697423285286''000000316159CED9''SECRET'"#{fingerprint_order}"

        params = {
          secret:                    'SECRET',
          'amount'                   => '21121221250.00',
          'currency'                 => 'EUR',
          'paymentType'              => 'CCARD',
          'financialInstitution'     => 'Visa',
          'language'                 => 'de',
          'orderNumber'              => '8300664',
          'paymentState'             => 'SUCCESS',
          'authenticated'            => 'No',
          'anonymousPan'             => '1122',
          'expiry'                   => '06/2018',
          'maskedPan'                => '405911******1122',
          'gatewayReferenceNumber'   => 'C101361143697423285286',
          'gatewayContractNumber'    => '000000316159CED9',
          'responseFingerprintOrder' => fingerprint_order,
          'responseFingerprint'      => 'd1e7ecba3980ca2da4954b9d154c1e1e',
        }
        checksum = described_class.new(params)
        expect(checksum).to_not be_valid
      end
    end
  end
end
