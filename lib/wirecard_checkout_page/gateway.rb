module WirecardCheckoutPage
  class Gateway

    attr_accessor :customer_id, :secret, :toolkit_password, :shop_id

    def initialize(customer_id: nil, secret: nil, toolkit_password: nil, shop_id: nil)
      @customer_id      = customer_id
      @secret           = secret
      @toolkit_password = toolkit_password
      @shop_id          = shop_id
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

    private

    def authentication_params
      params = { secret: secret, customerId: customer_id }
      params[:shopId] = shop_id if shop_id
      params
    end

    def toolkit_authentication_params
      authentication_params.merge( toolkitPassword: toolkit_password )
    end

  end
end
