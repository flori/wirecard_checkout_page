module WirecardCheckoutPage
  module Toolkit
    class Response
      attr_reader :original_response

      def initialize(response)
        @original_response = response
      end

      def success?

      end

      def status

      end

      def error_code

      end

      def message

      end
    end
  end
end

