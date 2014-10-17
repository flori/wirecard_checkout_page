require 'digest/md5'
require 'wirecard_checkout_page/errors'
require 'wirecard_checkout_page/utils'
require 'wirecard_checkout_page/request_checksum'
require 'wirecard_checkout_page/response_checksum'

module WirecardCheckoutPage
  INIT_URL = 'https://secure.wirecard-cee.com/wirecard_checkout_page/init.php'

  def self.response_valid?(values)
    ResponseChecksum.new(values).valid?
  end
end
