require 'wirecard_checkout_page/utils'

module WirecardCheckoutPage
  class CheckedResponse
    attr_reader :params

    def initialize(params)
      @params = WirecardCheckoutPage::Utils.stringify_keys(params).freeze
    end

    def valid?
      WirecardCheckoutPage::ResponseChecksum.new(@params).valid?
    end

    def success?
      valid? && @params['paymentState'] == 'SUCCESS'
    end

    def message
      @params['message']
    end
  end
end
