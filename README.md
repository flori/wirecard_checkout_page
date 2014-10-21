# WirecardCheckoutPage

## Example usage

Gateway setup
```ruby
gateway = WirecardCheckoutPage::Gateway.new(
  secret:     YOUR_SECRET,
  customerId: YOUR_ID
)
```

Init a new payment process
```ruby
params = {
  fingerprint_keys: ["secret", "customerId", "amount", ..], # Put in all your fingerprint keys
  currency:         'EUR',
  language:         'en',
  amount:           '100.00',
  paymentType:      'SELECT',
  orderDescription: 'Your order no 1',
  successURL:       'http://example.com/success',
  cancelURL:        'http://example.com/cancel',
  failureURL:       'http://example.com/failure',
  serviceURL:       'http://example.com/service',
  confirmURL:       'http://example.com/confirm',
  orderReference:   YOUR_UNIQUE_ORDER_REFERENCE,
}

response = gateway.init(params)

puts response.success?
#=> true

puts response.params
#=> { payment_url: 'http://example.com/redirect_your_user_to_here' }
```
