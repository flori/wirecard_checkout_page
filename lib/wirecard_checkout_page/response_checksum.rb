# encoding: utf-8
require 'wirecard_checkout_page/utils'
require 'wirecard_checkout_page/errors'

module WirecardCheckoutPage
  class ResponseChecksum
    attr_reader :params

    def initialize(params)
      @params = WirecardCheckoutPage::Utils.stringify_keys(params)
      if response_fingerprint_order_parts.include? 'secret'
        raise InvalidResponseFingerPrintOrder, 'Missing :secret as a part of the responseFingerprintOrder'
      end
    end

    def valid?
      params['responseFingerprint'] == computed_fingerprint
    end

    private

    def response_fingerprint_order_parts
      params['responseFingerprintOrder'].split(',')
    end

    def fingerprint_string
      response_fingerprint_order_parts.map {|key| params[key.to_s] }.join
    end

    def computed_fingerprint
      Digest::MD5.hexdigest fingerprint_string
    end

  end
end
