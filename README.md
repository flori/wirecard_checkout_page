# WirecardCheckoutPage

## Example usage

Gateway setup
```ruby
gateway = WirecardCheckoutPage::Gateway.new(
  customer_id: 'D200001',
  secret:      'B8AKTPWBRMNBV455FG6M2DANE99WU2',
)
```

Init a new payment process
```ruby
params = {
  amount:           '100.00',
  cancelUrl:        'https://foo.com/cancel',
  confirmUrl:       'https://foo.com/confirm',
  currency:         'EUR',
  failureUrl:       'https://foo.com/failure',
  language:         'en',
  orderDescription: 'order',
  orderReference:   '123',
  paymentType:      'SELECT',
  serviceUrl:       'https://foo.com/service',
  successUrl:       'https://foo.com/success',
}

response = gateway.init(params)

puts response.success?
#=> true

puts response.params
#=> { payment_url: 'http://example.com/redirect_your_user_to_here' }
```

## Badges

[![Code Climate](https://codeclimate.com/github/flori/wirecard_checkout_page/badges/gpa.svg)](https://codeclimate.com/github/flori/wirecard_checkout_page)

[![Test Coverage](https://codeclimate.com/github/flori/wirecard_checkout_page/badges/coverage.svg)](https://codeclimate.com/github/flori/wirecard_checkout_page)


## TODOS
[] Document the toolkit features
