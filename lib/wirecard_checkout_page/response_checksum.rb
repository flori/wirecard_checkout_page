# encoding: utf-8
require 'wirecard_checkout_page/utils'

module WirecardCheckoutPage
  class ResponseChecksum
    attr_reader :params

    def initialize(params)
      @params = WirecardCheckoutPage::Utils.stringify_keys(params)
    end

    def valid?
      params['responseFingerprint'] == computed_fingerprint
    end

    def fingerprint_string
      params['responseFingerprintOrder'].split(',').map {|key| params[key.to_s] }.join
    end

    def computed_fingerprint
      Digest::MD5.hexdigest fingerprint_string
    end

  end
end
