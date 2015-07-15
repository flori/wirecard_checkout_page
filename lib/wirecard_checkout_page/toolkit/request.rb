# Official Wirecard Checkout Page Docs for Toolkit Requests:
# https://integration.wirecard.at/doku.php/wcp:toolkit_light:start?s[]=toolkit
module WirecardCheckoutPage
  module Toolkit
    class Request < WirecardCheckoutPage::Request

      DEFAULT_URL = 'https://checkout.wirecard.com/page/toolkit.php'

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
      # param :customerId,      required: true
      # param :shopId
      # param :toolkitPassword, required: true
      # param :command,         required: true
      # param :language,        required: true


      def initialize(url: nil, params: {})
        super url: url || DEFAULT_URL, params: params
        self.language = 'en'
      end

      def call
        raise WirecardCheckoutPage::ValueMissing, errors.join(', ') unless valid?
        WirecardCheckoutPage::Toolkit::Response.from_typhoeus_response Typhoeus.post(url, body: body, headers: headers)
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
