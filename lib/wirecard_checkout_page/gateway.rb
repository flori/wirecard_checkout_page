module WirecardCheckoutPage
  class Gateway

    attr_accessor :customer_id, :secret, :toolkit_password

    def initialize(customer_id: nil, secret: nil, toolkit_password: nil)
      @customer_id      = customer_id
      @secret           = secret
      @toolkit_password = toolkit_password
    end

    def init(params = {})
      InitRequest.new(params: params.merge(authentication_params)).call
    end

    def recurring_init(params = {})
      RecurringInitRequest.new(params: params.merge(authentication_params)).call
    end

    def recurring_process(params = {})
      Toolkit::RecurPayment.new(params: params.merge(toolkit_authentication_params)).call
    end

    def check_response(params = {})
      CheckedResponse.new params.merge(authentication_params)
    end

    def authentication_params
      { secret: secret, customerId: customer_id }
    end

    def toolkit_authentication_params
      authentication_params.merge( toolkitPassword: toolkit_password )
    end

  end
end
