module WirecardCheckoutPage
  class WirecardCheckoutPageError < StandardError; end

  class ValueMissing < WirecardCheckoutPageError; end

  class ChecksumCreationFailed < WirecardCheckoutPageError; end

  class ChecksumVerificationFailed < WirecardCheckoutPageError; end
end
