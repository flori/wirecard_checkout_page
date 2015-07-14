# Official Wirecard Checkout Page Docs for Toolkit Requests:
# https://integration.wirecard.at/doku.php/wcp:toolkit_light:start?s[]=toolkit
module WirecardCheckoutPage
  module Toolkit
    class Request
      include WirecardCheckoutPage::Utils

      DEFAULT_URL = 'https://checkout.wirecard.com/page/toolkit.php'

      attr_reader :url, :request_params

      def initialize(url: nil, command: nil, params: {})
        @url                        = url || DEFAULT_URL
        @original_params            = stringify_keys params
        @request_params             = @original_params.dup
        @request_params['command']  = command
        @request_params['language'] = 'en'
        @secret                     = @request_params.delete 'secret'

        @fingerprint = Fingerprint.new @secret, fingerprint_keys, optional_keys, @request_params
      end

      def call
        if missing_keys.any?
          raise WirecardCheckoutPage::ValueMissing, "values #{missing_keys * ', ' } are missing"
        end
        WirecardCheckoutPage::Toolkit::Response.from_typhoeus_response Typhoeus.post(url, body: body, headers: headers)
      end

      # Which request parameters are required for all operations?
      # To start an operation you have to set all required parameters to their corresponding values.
      # If one or more of these required parameters are missing you will get an error message.

      # Parameter          Data type                               Short description
      # customerId         Alphanumeric with a fixed length of 7.  Unique ID of merchant.
      # toolkitPassword    Alphanumeric with special characters.   Your password for Toolkit light operations.
      # command            Enumeration                             Operation to be executed.
      # language           Alphabetic with a fixed length of 2.    Language for returned texts and error messages,
      #                                                            currently only “en” is supported; we are able
      #                                                            to integrate other languages upon request.
      # requestFingerprint Alphanumeric with a fixed length of 32. Computed fingerprint of the parameter
      #                                                            values and the secret.
      def fingerprint_keys
        %w[
          customerId
          shopId
          toolkitPassword
          secret
          command
          language
        ]
      end

      # Which request parameters are optional?
      # Parameter Data type                                  Short description
      # shopId    Alphanumeric with a variable length of 16. Unique ID of your online shop if several
      #                                                      configurations are used within one customerId.
      def optional_keys
        %w[shopId]
      end

      def missing_keys
        @missing_keys = (@fingerprint.missing_keys - %w[command language])
      end

      def body
        @fingerprint.fingerprinted_params
      end

      # HTTP header parameter	Description
      # Host           Domain name of server. Has to be set to the following value: secure.wirecard-cee.com
      # User-Agent     User agent string of client. (Should be set by the HTTP-Client lib)
      # Content-Length Length of body in bytes. (Should be set by HTTP-Client lib)
      # Content-Type   MIME type of the body. Has to be set to the following value: application/x-www-form-urlencoded
      # Connection     Type of connection. Has to be set to the following value: close
      def headers
        {
          'Host'         => 'secure.wirecard-cee.com',
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Connection'   => 'close',
        }
      end

    end
  end
end
