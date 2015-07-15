# works like ActiveMerchant::Billing::Response to maintain compatibility to
# active merchant gateways

module WirecardCheckoutPage
  class InitResponse

    attr_reader :original_response, :body

    def self.from_typhoeus_response(response)
      new(response.body, original_response: response)
    end

    def initialize(body, original_response: nil)
      @body = body
      @original_response = original_response
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
