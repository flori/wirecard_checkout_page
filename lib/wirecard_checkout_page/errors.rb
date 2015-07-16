module WirecardCheckoutPage
  class WirecardCheckoutPageError < StandardError; end

  class ValueMissing < WirecardCheckoutPageError; end
  class NotImplementedError < WirecardCheckoutPageError; end
  class InvalidResponseFingerPrintOrder < WirecardCheckoutPageError; end
end
