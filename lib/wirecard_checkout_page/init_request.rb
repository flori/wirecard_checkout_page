module WirecardCheckoutPage
  class InitRequest < Request

    DEFAULT_URL = 'https://checkout.wirecard.com/page/init.php'

    def initialize(url: nil, params: {})
      super url: url || DEFAULT_URL, params: params
      self.transactionIdentifier = 'SINGLE'
    end

    # Parameter        Within fingerprint Data type	Short description
    # customerId       Required           Alphanumeric with a fixed length of 7. Unique ID of merchant.
    # language         Required           Alphabetic with a fixed length of 2.   Language for displayed texts on payment page.
    # paymentType      Optional           Enumeration	Selected payment method of your consumer.
    # amount           Required           Amount                                 Amount of payment.
    # currency         required           Alphabetic with a fixed length of 3 or numeric with a fixed length of 3.	Currency code of amount.
    # orderDescription Required           Alphanumeric with a variable length of up to 255.	Unique description of the consumer's order in a human readable form.
    # successUrl       Required           Alphanumeric with special characters.  URL of your online shop when payment process was successful.
    # cancelUrl        Optional           Alphanumeric with special characters.  URL of your online shop when payment process has been canceled.
    # failureUrl       Optional           Alphanumeric with special characters.  URL of your online shop when an error occured within payment process.
    # serviceUrl       Optional           Alphanumeric with special characters and a variable length of up to 255.	URL of your service page containing contact information.

    param :secret,           required: true
    param :customerId,       required: true
    param :language,         required: true
    param :paymentType,      required: true
    param :amount,           required: true
    param :currency,         required: true
    param :orderDescription, required: true
    param :successUrl,       required: true
    param :cancelUrl,        required: true # Seems to be required even if the docs say otherwise
    param :failureUrl,       required: true # Seems to be required even if the docs say otherwise
    param :serviceUrl,       required: true # Seems to be required even if the docs say otherwise

    # Parameter             Within fingerprint Data type	Short description
    # pendingUrl            Optional           Alphanumeric with special characters.	URL of your online shop when result of payment process could not be determined yet.
    # confirmUrl            Required if used.  Alphanumeric with special characters.	URL of your online shop where Wirecard sends a server-to-server confirmation.
    # noScriptInfoUrl       Optional           Alphanumeric with special characters.	URL of your online shop where your information page regarding de-activated JavaScript resides.
    # orderNumber           Required if used.  Numeric with a variable length of up to 9.	Order number of payment.
    # windowName            Optional           Alphanumeric	Window name of browser window where payment page is opened.
    # duplicateRequestCheck Required if used.  Boolean (“yes” or “no”).	Check for duplicate requests done by your consumer.
    # customerStatement     Required if used.  Alphanumeric with a variable length of up to 254 characters, but may differ for specific payment methods.	Text displayed on invoice of financial institution of your consumer.
    # orderReference        Required if used.  Alphanumeric with a variable length up to 128 characters, but may differ for specific payment methods.	Unique order reference ID sent from merchant to financial institution.
    # transactionIdentifier Required if used.  Enumeration	Possible values are SINGLE (for one-off transactions) or INITIAL (for the first transaction of a series of recurring transactions).

    param :pendingUrl
    param :confirmUrl,        required: true # Seems to be required even if the docs say otherwise
    param :noScriptInfoUrl
    param :orderNumber
    param :windowName
    param :duplicateRequestCheck
    param :customerStatement
    param :orderReference
    param :transactionIdentifier

    def fingerprint_order
      super + [:requestFingerprintOrder]
    end

    def requestFingerprintOrder
      fingerprint_order * ','
    end

    def call
      raise WirecardCheckoutPage::ValueMissing, errors.join(', ') unless valid?
      InitResponse.from_typhoeus_response Typhoeus.post(DEFAULT_URL, body: body)
    end

  end
end
