module WirecardCheckoutPage
  module Toolkit
    class Request
      include WirecardCheckoutPage::Utils

      DEFAULT_URL = 'https://checkout.wirecard.com/page/toolkit.php'

      attr_reader :url, :command, :params

      def initialize(url: nil, command: nil, params: {})
        @url         = url || DEFAULT_URL
        @command     = command
        @params      = stringify_keys params
      end

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

      def required_fingerprint_keys
        @required_fingerprint_keys ||= (fingerprint_keys - missing_optional_keys)
      end

      def missing_optional_keys
        @missing_optional_keys ||= (optional_keys - request_params.keys)
      end

      def missing_keys
        @missing_keys = (required_fingerprint_keys - request_params.keys)
      end

      def call
        if missing_keys.any?
          raise WirecardCheckoutPage::ValueMissing, "values #{missing_keys * ', ' } are missing"
        end
        WirecardCheckoutPage::Toolkit::Response.new Typhoeus.post(url, body: fingerprinted_request_params, headers: headers)
      end

      def request_params
        @request_params ||= ({
          'command'  => command,
          'language' => 'en',
        }.merge params)
      end

      def fingerprinted_request_params
        request_params.merge(
          'requestFingerprint'      => fingerprint,
          'requestFingerprintOrder' => required_fingerprint_keys.join(',')
        )
      end

      # HTTP header parameter	Description
      # Host           Domain name of server. Has to be set to the following value: secure.wirecard-cee.com
      # User-Agent     User agent string of client.
      # Content-Type   MIME type of the body. Has to be set to the following value: application/x-www-form-urlencoded
      # Content-Length Length of body in bytes.
      # Connection     Type of connection. Has to be set to the following value: close
      def headers
        {
          'Host'         => 'secure.wirecard-cee.com',
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Connection'   => 'close',
        }
      end

      # How is the fingerprint computed?
      # The fingerprint is computed by concatenating all request parameters and your secret without
      # any dividers in between. If you do not use optional parameters you have to ignore them in
      # your fingerprint string.
      # Please be aware that the concatenation of the request parameters and the secret has to be
      # done in the order as defined within the detailed description of each operation.
      # After concatenating all values to a single string you use a MD5 hash and the result is the
      # fingerprint which you add as a request parameter to the server-to-server call.
      # The Wirecard Checkout Server knows also your secret and is able to check if the received
      # parameters are not manipulated by a 3rd party. Therefore it is essential that only you and
      # Wirecard know your secret!
      def fingerprint
        values = required_fingerprint_keys.map { |key| request_params[key] } * ''
        Digest::MD5.hexdigest values
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

      # For testing purposes in demo mode and customerId D200001, the value jcv45z
      # is to be used as toolkitPassword for Toolkit light operations.
      def required_attributes
        # %w[customerId toolkitPassword command language requestFingerprint]
        fingerprint_keys - optional_keys
      end

      # Which request parameters are optional?
      # Parameter Data type                                  Short description
      # shopId    Alphanumeric with a variable length of 16. Unique ID of your online shop if several
      #                                                      configurations are used within one customerId.
      def optional_keys
        %w[shopId]
      end

    end
  end
end
