module WirecardCheckoutPage
  class WirecardCheckoutPageError < StandardError; end

  class ValueMissing < WirecardCheckoutPageError; end
end
