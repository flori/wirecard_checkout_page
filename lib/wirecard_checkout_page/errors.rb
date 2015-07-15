module WirecardCheckoutPage
  class WirecardCheckoutPageError < StandardError; end

  class ValueMissing < WirecardCheckoutPageError; end
  class NotImplementedError < WirecardCheckoutPageError; end
end
