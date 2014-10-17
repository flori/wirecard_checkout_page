# encoding: utf-8

module WirecardCheckoutPage
  class ResponseChecksum
    include WirecardCheckoutPage::Utils

    def initialize(values = {})
      @values = stringify_keys(values)
      @secret = @values.delete('secret') or
        raise WirecardCheckoutPage::ValueMissing, "secret is missing"
      # This rails form value is escaped as an html entity by
      # WirecardCheckoutPage, so set it back to the original UTF-8 here if it
      # exists:
      @values['utf8'] and @values['utf8'] = '✓'
      @values.freeze
      @missing_keys = []
    end

    attr_reader :values

    attr_reader :expected_fingerprint

    attr_reader :computed_fingerprint

    def fingerprint
      values = @values.dup
      values['secret'] ||= @secret
      if seed = responseFingerprintSeed(responseFingerprintOrder(values), values)
        Digest::MD5.hexdigest seed
      end
    end

    def missing_keys?
      unless @missing_keys.empty?
        @missing_keys
      end
    end

    def valid?
      @missing_keys.clear
      @expected_fingerprint = values.fetch('responseFingerprint') do |k|
        @missing_keys << k
      end
      @computed_fingerprint = fingerprint
      !missing_keys? && computed_fingerprint == @expected_fingerprint
    end

    private

    def responseFingerprintOrder(values)
      order = values.fetch('responseFingerprintOrder') do |k|
        @missing_keys << k
        return []
      end
      order.split(',')
    end

    def responseFingerprintSeed(keys, values)
      fingerprint = keys.map do |k|
        values.fetch(k) do
          @missing_keys << k
        end
      end * ''
      fingerprint if @missing_keys.empty?
    end
  end
end
