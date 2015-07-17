# encoding: utf-8

module WirecardCheckoutPage
  class ResponseChecksum
    include WirecardCheckoutPage::Utils

    def initialize(params)
      @params = stringify_keys(params)
      unless response_fingerprint_order_parts.include? 'secret'
        raise InvalidResponseFingerPrintOrder, 'Missing :secret as a part of the responseFingerprintOrder'
      end
    end

    attr_reader :params

    def valid?
      params['responseFingerprint'] == computed_fingerprint
    end

    private

    def response_fingerprint_order_parts
      params['responseFingerprintOrder'].to_s.split(',')
    end

    def fingerprint_string
      response_fingerprint_order_parts.map {|key| params[key.to_s] }.join
    end

    def computed_fingerprint
      Digest::MD5.hexdigest fingerprint_string
    end
  end
end
