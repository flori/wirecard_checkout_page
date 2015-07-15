module WirecardCheckoutPage
  module Toolkit
    class RecurPayment < Request

      def initialize(params: {})
        super params: params
        self.command = 'recurPayment'
      end

      # Which request parameters are required for all operations?
      # To start an operation you have to set all required parameters to their corresponding values.
      # If one or more of these required parameters are missing you will get an error message.

      # Parameter          Data type                               Short description
      # customerId         Alphanumeric with a fixed length of 7.  Unique ID of merchant.
      # shopId             Alphanumeric with a variable length of 16. Unique ID of your online shop if several
      # toolkitPassword    Alphanumeric with special characters.   Your password for Toolkit light operations.
      # command            Enumeration                             Operation to be executed.
      # language           Alphabetic with a fixed length of 2.    Language for returned texts and error messages,
      #                                                            currently only “en” is supported; we are able
      #                                                            to integrate other languages upon request.
      # requestFingerprint Alphanumeric with a fixed length of 32. Computed fingerprint of the parameter
      #                                                            values and the secret.
      param :customerId,      required: true
      param :shopId
      param :toolkitPassword, required: true
      param :secret,          required: true
      param :command,         required: true
      param :language,        required: true

      # Additional required request parameters
      #
      # Parameter         Data type                             Short description
      # amount            Amount                                Debit amount.
      # currency          Alphabetic with a fixed length of 3   Currency code of amount.
      #                   or numeric with a fixed length of 3.
      # orderDescription  Alphanumeric with a variable length   Textual description of order.
      #                   of up to 255 characters.
      # sourceOrderNumber Numeric with a variable length of     Original order number used for new payment.
      #                   up to 9 digits.

      # Additional optional request parameters
      #
      # Parameter         Data type                             Short description
      # autoDeposit       Enumeration                           Possible values are Yes and No.
      #                                                         Yes is used for enabling and No for
      #                                                         disabling automated deposit and
      #                                                         day-end closing of payments.
      # customerStatement Alphanumeric with a variable length   Text displayed on invoice of
      #                   of up to 254 characters.              financial institution of your consumer.
      # orderNumber       Numeric with a variable length        Order number of payment.
      #                   of up to 9 digits.
      # orderReference    Alphanumeric with a variable length   Unique order reference ID sent from
      #                   of up to 128 characters.              merchant to financial institution.
      param :orderNumber
      param :sourceOrderNumber, required: true
      param :autoDeposit
      param :orderDescription,  required: true
      param :amount,            required: true
      param :currency,          required: true
      param :orderReference
      param :customerStatement


    end
  end
end
