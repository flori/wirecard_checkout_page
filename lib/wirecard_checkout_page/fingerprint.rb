module WirecardCheckoutPage
  class Fingerprint

    attr_reader :secret, :key_order, :optional_keys, :params

    def initialize(secret, key_order, optional_keys, params)
      @secret        = secret
      @key_order     = key_order
      @optional_keys = optional_keys
      @params        = params
    end

    def required_keys
      @required_keys ||= (key_order - missing_optional_keys)
    end

    def missing_optional_keys
      @missing_optional_keys ||= (optional_keys - params.keys)
    end

    def missing_keys
      @missing_keys = (required_keys - params.keys - ['secret'])
    end

    # How is the fingerprint computed?
    # The fingerprint is computed by concatenating all request parameters and your secret without
    # any dividers in between. If you do not use optional parameters you have to ignore them in
    # your fingerprint string.
    # Please be aware that the concatenation of the request parameters and the secret has to be
    # done in the order as defined within the detailed description of each operation.
    # After concatenating all values to a single string you use a MD5 hash and the result is the
    # fingerprint which you add as a request parameter to the server-to-server call.
    # The Wirecard Checkout Server knows also your secret and is able to check if the received
    # parameters are not manipulated by a 3rd party. Therefore it is essential that only you and
    # Wirecard know your secret!
    def to_s
      values = required_keys.map do |key|
        if key == 'secret'
          @secret
        else
          params[key]
        end
      end * ''
      Digest::MD5.hexdigest values
    end

    def fingerprinted_params
      params.merge(
        'requestFingerprint'      => to_s,
        'requestFingerprintOrder' => required_keys.join(',')
      )
    end
  end
end
