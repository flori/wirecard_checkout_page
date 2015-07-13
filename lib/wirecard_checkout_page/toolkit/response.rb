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
        parsed_body['errorCode'].last.to_s
      end

      private

      # NOTE: May be useful for debugging? Expose later?
      def status
        parsed_body['status'].last
      end

      def parsed_body
        @parsed_body ||= CGI::parse(body)
      end
    end
  end
end

