if ENV['START_SIMPLECOV'].to_i == 1
  require 'simplecov'
  SimpleCov.start do
    add_filter "#{File.basename(File.dirname(__FILE__))}/"
  end
end
require 'rspec'
require 'byebug'
require 'wirecard_checkout_page'

RSpec.configure do |config|
  config.before(:all) do
    response = Typhoeus::Response.new(code: 302, body: "", headers: { 'Location' => 'payment-url' })
    Typhoeus.stub(/init/).and_return(response)
  end
end
