# frozen_string_literal: true

class TestData # rubocop:disable Metrics/ClassLength
  def self.card
    {
      'number' => '4242424242424242',
      'expMonth' => '12',
      'expYear' => '55',
      'cvc' => '123',
      'cardholderName' => random_string,
    }.compact
  end

  def self.disputed_card
    {
      'number' => '4242000000000018',
      'expMonth' => '12',
      'expYear' => '55',
      'cvc' => '123',
      'cardholderName' => random_string,
    }.compact
  end

  def self.fraud_warning_card
    {
      'number' => '4242000000000208',
      'expMonth' => '12',
      'expYear' => '55',
      'cvc' => '123',
      'cardholderName' => random_string,
    }.compact
  end

  def self.charge(
    card: nil,
    customer_id: nil,
    captured: nil
  )
    {
      'amount' => 1000,
      'captured' => captured,
      'currency' => 'EUR',
      'description' => 'description',
      'card' => card,
      'customerId' => customer_id,
      'metadata' => { 'key' => 'value' },
    }.compact
  end

  def self.charge_with_tip_split(
    card: nil,
    customer_id: nil,
    captured: nil,
    platform_merchant: nil,
    tip_value: 1
  )
    base_charge = charge(card: card, customer_id: customer_id, captured: captured)
    base_charge['splits'] = [
      {
        'type' => 'tip',
        'merchant' => platform_merchant,
        'amount' => tip_value
      }.compact
    ]
    base_charge
  end

  def self.credit(
    card: nil,
    customer_id: nil
  )
    {
      'amount' => 1000,
      'currency' => 'EUR',
      'description' => 'description',
      'card' => card,
      'customerId' => customer_id,
      'metadata' => { 'key' => 'value' },
    }.compact
  end

  def self.customer(
    card: nil,
    email: random_email
  )
    {
      'email' => email,
      'card' => card,
    }.compact
  end

  def self.plan(
    amount: 1000,
    currency: 'EUR',
    interval: 'month',
    name: "Plan: #{random_string}"
  )
    {
      'amount' => amount,
      'currency' => currency,
      'interval' => interval,
      'name' => name,
    }.compact
  end

  def self.payment_method(
    customer_id: nil
  )
    {
      'type' => 'alipay',
      'customerId' => customer_id,
      'billing' => {
        'name' => 'Nikola Tesla',
        'address' => {
          'country' => 'CN'
        }
      }.compact
    }.compact
  end
end
