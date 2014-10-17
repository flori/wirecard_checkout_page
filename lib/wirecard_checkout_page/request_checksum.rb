module WirecardCheckoutPage
  class RequestChecksum
    include WirecardCheckoutPage::Utils

    FINGERPRINT_KEYS = %w[
      secret
      customerId
      amount
      paymentType
      currency
      language
      orderDescription
      serviceURL
      successURL
      cancelURL
      failureURL
      confirmURL
      orderReference
      requestFingerprintOrder
    ].freeze

    def initialize(values = {})
      @values = stringify_keys(values)
      @init_url = @values.delete('init_url') || WirecardCheckoutPage::DEFAULT_INIT_URL
      @fingerprint_keys = @values.delete('fingerprint_keys') || FINGERPRINT_KEYS
      @secret = @values.delete('secret') or
        raise WirecardCheckoutPage::ValueMissing, "secret is missing"
      @values = add_some_defaults @values
      @values.freeze
      @fingerprint_keys = fingerprint_keys
      @secret = @secret
    end

    attr_reader :fingerprint_keys

    attr_reader :values

    def fingerprint
      values = @values.dup
      values.update(
        'requestFingerprintOrder' => requestFingerprintOrder,
        'secret'                  => @secret,
      )
      Digest::MD5.hexdigest requestFingerprintSeed(values)
    end

    def request_parameters
      parameters = @values.dup
      parameters['requestFingerprintOrder'] = requestFingerprintOrder
      parameters['requestFingerprint'] = fingerprint
      parameters
    end

    def request_url
      url = URI.parse(@init_url)
      url.query = request_parameters.to_param
      url
    end

    private

    def requestFingerprintSeed(values)
      fingerprint_keys.map { |k| values.fetch(k) } * ''
    rescue KeyError => e
      raise ChecksumCreationFailed, e.message
    end

    def requestFingerprintOrder
      @requestFingerprintOrder ||= fingerprint_keys.join(',').freeze
    end

    def add_some_defaults(values)
      default_tokens = {
        'paymentType'             => 'SELECT',
        'currency'                => 'EUR',
        'language'                => 'de',

      }
      values.update(default_tokens) do |key,old,new|
        old.nil? ? new : old
      end
    end
  end
end
