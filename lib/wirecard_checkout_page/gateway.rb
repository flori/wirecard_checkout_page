module WirecardCheckoutPage
  class Gateway
    DEFAULT_INIT_URL    = 'https://checkout.wirecard.com/page/init.php'
    DEFAULT_TOOLKIT_URL = 'https://checkout.wirecard.com/page/toolkit.php'

    attr_accessor :customerId, :secret, :init_url, :toolkit_url, :toolkit_password

    def initialize(customerId: nil, secret: nil, init_url: nil, toolkit_url: nil, toolkit_password: nil)
      @customerId       = customerId
      @secret           = secret
      @init_url         = init_url    || DEFAULT_INIT_URL
      @toolkit_url      = toolkit_url || DEFAULT_TOOLKIT_URL
      @toolkit_password = toolkit_password
    end

    def init(params = {})
      checksum = WirecardCheckoutPage::RequestChecksum.new(params.merge(authentication_params))
      InitResponse.new Typhoeus.post(init_url, body: checksum.request_parameters)
    end

    # def single(params = {})
    #   SingleResponse.new SingleRequest.new(init_url, params).call
    # end

    # to initialize a recurring payment
    def recurring_init(params = {})
      InitialResponse.new InitialRequest.new(init_url, params).call
    end

    # to execute the recurring payments
    def recurring_process(params = {})
      Toolkit::RecurPayment.new(
        url: toolkit_url,
        params: params.merge(credentials)
      ).call
    end

    def check_response(params = {})
      CheckedResponse.new params.merge(authentication_params)
    end

    def authentication_params
      { secret: secret, customerId: customerId }
    end

    def credentials
      authentication_params.merge(toolkitPassword: toolkit_password)
    end

  end
end
