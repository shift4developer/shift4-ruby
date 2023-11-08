Shift4 ruby gem
====================

[![Build](https://github.com/shift4developer/shift4-ruby/actions/workflows/build.yml/badge.svg)](https://github.com/shift4developer/shift4-ruby/actions/workflows/build.yml)
[![Gem Version](https://badge.fury.io/rb/shift4.svg)](https://badge.fury.io/rb/shift4)

If you don't already have Shift4 account you can create it [here](https://dev.shift4.com/signup).

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem 'shift4'
```

And then execute:

```bash
bundle
```

Or install it yourself as:

```bash
gem install shift4
```

Usage
-----

Configuration:

```ruby
Shift4::Configuration.secret_key = 'pr_test_id'
```

If you want connect to different backend:

```ruby
Shift4::Configuration.api_url = 'https://api.myshift4.env'
Shift4::Configuration.uploads_url = 'https://uploads.myshift4.env'
```

Examples
--------

### Create a new Card

Creates a new card object.

```ruby
customer_id = 'cust_id'
card = {
  number: '4242424242424242',
  expMonth: '11',
  expYear: '2022',
  cvc: '123',
  cardholderName: 'John Doe',
}

Shift4::Cards.create(customer_id, card)
```

### Retrieve an existing Card

Retrieve an existing card object.

```ruby
customer_id = 'cust_id'
card_id = 'card_id'

Shift4::Cards.retrieve(customer_id, card_id)
```

### Update an existing Card

Update an existing card object.

```ruby
customer_id = 'cust_id'
card_id = 'card_id'
card = {
  cardholderName: 'Mr Bean'
}
Shift4::Cards.update(customer_id, card_id, card)
```

### Delete a Card

Deletes an existing card object.

```ruby
customer_id = 'cust_id'
card_id = 'card_id'
Shift4::Cards.delete(customer_id, card_id)
```

### List Cards

List card objects for given customer.

```ruby
customer_id = 'cust_id'
Shift4::Cards.list(customer_id)
```

### Create a Blacklist Rule

```ruby
blacklist_rule = {
  ruleType: 'fingerprint',
  fingerprint: '123abc456efg'
}
Shift4::Blacklist.create(blacklist_rule)
```

### Retrieve an existing Blacklist Rule

```ruby
blacklist_rule_id = 'blr_number'
Shift4::Blacklist.retrieve(blacklist_rule_id)
```

### Delete a Blacklist Rule

```ruby
blacklist_rule_id = 'blr_number'
Shift4::Blacklist.delete(blacklist_rule_id)
```

### List Blacklist Rules

```ruby
Shift4::Blacklist.list(deleted: true, limit: 100)
```


API reference
-------------

Please refer to detailed API docs (linked) for all available fields

- charges
    - [create(params)](https://dev.shift4.com/docs/api#charge-create)
    - [retrieve(charge_id)](https://dev.shift4.com/docs/api#charge-retrieve)
    - [update(charge_id, params)](https://dev.shift4.com/docs/api#charge-update)
    - [capture(charge_id)](https://dev.shift4.com/docs/api#charge-capture)
    - [refund(charge_id, [params])](https://dev.shift4.com/docs/api#charge-capture)
    - [list([params])](https://dev.shift4.com/docs/api#charge-list)
- customers
    - [create(params)](https://dev.shift4.com/docs/api#customer-create)
    - [retrieve(customer_id)](https://dev.shift4.com/docs/api#customer-retrieve)
    - [update(customer_id, params)](https://dev.shift4.com/docs/api#customer-update)
    - [delete(customer_id)](https://dev.shift4.com/docs/api#customer-delete)
    - [list([params])](https://dev.shift4.com/docs/api#customer-list)
- cards
    - [create(customer_id, params)](https://dev.shift4.com/docs/api#card-create)
    - [retrieve(customer_id, card_id)](https://dev.shift4.com/docs/api#card-retrieve)
    - [update(customer_id, card_id, params)](https://dev.shift4.com/docs/api#card-update)
    - [delete(customer_id, card_id)](https://dev.shift4.com/docs/api#card-delete)
    - [list(customer_id, [params])](https://dev.shift4.com/docs/api#card-list)
- subscriptions
    - [create(params)](https://dev.shift4.com/docs/api#subscription-create)
    - [retrieve(subscription_id)](https://dev.shift4.com/docs/api#subscription-retrieve)
    - [update(subscription_id, params)](https://dev.shift4.com/docs/api#subscription-update)
    - [cancel(subscription_id, [params])](https://dev.shift4.com/docs/api#subscription-cancel)
    - [list([params])](https://dev.shift4.com/docs/api#subscription-list)
- plans
    - [create(params)](https://dev.shift4.com/docs/api#plan-create)
    - [retrieve(plan_id)](https://dev.shift4.com/docs/api#plan-retrieve)
    - [update(plan_id, params)](https://dev.shift4.com/docs/api#plan-update)
    - [delete(plan_id)](https://dev.shift4.com/docs/api#plan-delete)
    - [list([params])](https://dev.shift4.com/docs/api#plan-list)
- events
    - [retrieve(event_id)](https://dev.shift4.com/docs/api#event-retrieve)
    - [list([params])](https://dev.shift4.com/docs/api#event-list)
- tokens
    - [create(params)](https://dev.shift4.com/docs/api#token-create)
    - [retrieve(token_id)](https://dev.shift4.com/docs/api#token-retrieve)
- blacklist
    - [create(params)](https://dev.shift4.com/docs/api#blacklist-rule-create)
    - [retrieve(blacklist_rule_id)](https://dev.shift4.com/docs/api#blacklist-rule-retrieve)
    - [delete(blacklist_rule_id)](https://dev.shift4.com/docs/api#blacklist-rule-delete)
    - [list([params])](https://dev.shift4.com/docs/api#blacklist-rule-list)
- checkoutRequest
    - [sign(checkoutRequestObjectOrJson)](https://dev.shift4.com/docs/api#checkout-request-sign)
- credits
    - [create(params)](https://dev.shift4.com/docs/api#credit-create)
    - [retrieve(credit_id)](https://dev.shift4.com/docs/api#credit-retrieve)
    - [update(credit_id, params)](https://dev.shift4.com/docs/api#credit-update)
    - [list([params])](https://dev.shift4.com/docs/api#credit-list)
- disputes
    - [retrieve(dispute_id)](https://dev.shift4.com/docs/api#dispute-retrieve)
    - [update(dispute_id, params)](https://dev.shift4.com/docs/api#dispute-update)
    - [close(dispute_id)](https://dev.shift4.com/docs/api#dispute-close)
    - [list([params])](https://dev.shift4.com/docs/api#dispute-list)
- fileUploads
    - [upload(content, params)](https://dev.shift4.com/docs/api#file-upload-create)
    - [retrieve(file_upload_id)](https://dev.shift4.com/docs/api#file-upload-retrieve)
    - [list([params])](https://dev.shift4.com/docs/api#file-upload-list)
- fraudWarnings
    - [retrieve(fraud_warning_id)](https://dev.shift4.com/docs/api#fraud-warning-retrieve)
    - [list([params])](https://dev.shift4.com/docs/api#fraud-warning-list)
- paymentMethods
    - [create(params)](https://dev.shift4.com/docs/api#payment-method-create)
    - [retrieve(payment_method_id)](https://dev.shift4.com/docs/api#payment-method-retrieve)
    - [delete(payment_method_id)](https://dev.shift4.com/docs/api#payment-method-delete)
    - [list([params])](https://dev.shift4.com/docs/api#payment-methods-list)


For further information, please refer to our official documentation at [https://dev.shift4.com/docs](https://dev.shift4.com/docs).


Contributing
------------
Bug reports and pull requests are welcome on GitHub at [https://github.com/shift4developer/shift4-ruby](https://github.com/shift4developer/shift4-ruby)


Development
------------
After checking out the repo, run `bundle setup` to install dependencies.

To run integration tests:

```bash
SECRET_KEY='sk_test_id' bundle exec rake spec:integration
```

To run style checks execute:

```bash
bundle exec rubocop
```