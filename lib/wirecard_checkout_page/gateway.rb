module WirecardCheckoutPage
  class Gateway
    DEFAULT_INIT_URL = 'https://checkout.wirecard.com/page/init.php'

    attr_accessor :customerId, :secret, :init_url

    def initialize(customerId: nil, secret: nil, init_url: nil)
      @customerId = customerId
      @secret     = secret
      @init_url   = init_url || DEFAULT_INIT_URL
    end

    def init(params = {})
      checksum = WirecardCheckoutPage::RequestChecksum.new(params.merge(authentication_params))
      InitResponse.new Typhoeus.post(init_url, body: checksum.request_parameters)
    end

    def response_valid?(params = {})
      WirecardCheckoutPage::ResponseChecksum.new(params.merge(authentication_params)).valid?
    end

    private

    def authentication_params
      { secret: secret, customerId: customerId }
    end

  end
end
