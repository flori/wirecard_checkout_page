module WirecardCheckoutPage
  module Toolkit
    class RecurPayment < Request

      def initialize(url: nil, params: {})
        super url: url, command: 'recurPayment', params: params
      end

      def fingerprint_keys
        super + %w[
          orderNumber
          sourceOrderNumber
          autoDeposit
          orderDescription
          amount
          currency
          orderReference
          customerStatement
        ]
      end

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
      # def required_attributes
      #   #super + %w[amount currency orderDescription sourceOrderNumber]
      #   fingerprint_keys - optional_keys
      # end

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
      def optional_keys
        super + %w[autoDeposit customerStatement orderNumber orderReference]
      end

    end
  end
end
