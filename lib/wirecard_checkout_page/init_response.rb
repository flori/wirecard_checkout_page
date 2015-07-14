# works like ActiveMerchant::Billing::Response to maintain compatibility to
# active merchant gateways

module WirecardCheckoutPage
  class InitResponse

    attr_reader :original_response

    def initialize(response)
      @original_response = response
    end

    def params
      {
        payment_url: @original_response.headers['Location']
      }
    end

    def success?
      !!params[:payment_url]
    end

    def message
      @original_response.body
    end
  end
end
