require 'cgi'

module WirecardCheckoutPage
  module Toolkit
    class Response
      attr_reader :original_response, :body

      def self.from_typhoeus_response(response)
        new(response.body, original_response: response)
      end

      def initialize(body, original_response: nil)
        @body = body
        @original_response = original_response
      end

      def success?
        status == '0'
      end

      def error_code
        param('errorCode').to_s
      end

      def order_number
        param('orderNumber').to_i
      end

      def params
        { payment_url: original_response.headers['Location'] }
      end

      def to_s
        body
      end

      private

      def status
        param 'status'
      end

      def param(key)
        parsed_body[key].last
      end

      def parsed_body
        @parsed_body ||= CGI::parse(body)
      end
    end
  end
end

