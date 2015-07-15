module WirecardCheckoutPage
  class Request

    def self.param(name, options = {})
      name = name.to_sym
      params_order << name
      params[name] = options
      attr_accessor name
    end

    def self.params
      @params ||= {}
    end

    def self.params_order
      @params_order ||= []
    end

    attr_reader :url, :params, :errors

    def initialize(url: nil, params: {})
      @url = url
      params.each { |param, value| send "#{param}=", value }
    end

    def valid?
      @errors = []
      attributes.each do |param, options|
        next unless options[:required] == true
        val = send param
        @errors << "#{param} is required" if val.nil? || val == ''
      end
      @errors.empty?
    end

    def body
      fingerprinted_request_params
    end

    def call
      raise NotImplementedError, '#call not implemented'
    end

    def fingerprint_string
      fingerprint_order.each_with_object('') { |param, str| str << send(param).to_s }
    end

    def fingerprint
      Digest::MD5.hexdigest fingerprint_string
    end

    def fingerprint_order
      self.class.params_order.select do |param|
        attributes[param][:required] || send(param).to_s != ''
      end
    end

    def request_params
      rp = {}
      attributes.keys.each do |param|
        next if param == :secret
        val = send(param).to_s
        next if val == ''
        rp[param.to_s] = val
      end
      rp
    end

    def fingerprinted_request_params
      request_params.merge(
        'requestFingerprint'      => fingerprint,
        'requestFingerprintOrder' => fingerprint_order.join(',')
      )
    end

    private

    def attributes
      self.class.params
    end

  end
end
