# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::Charges do
  context 'with no secret key in config' do
    include_context 'with no secret key in config'

    it 'create and retrieve charge using explicit merchant' do
      # given
      charge_req = TestData.charge(card: TestData.card)

      # when
      configuration = Shift4::Configuration.new(
        merchant: ENV.fetch('EXPLICIT_MERCHANT'),
        secret_key: ENV.fetch('EXPLICIT_MERCHANT_SECRET_KEY')
      )
      created = Shift4::Charges.create(charge_req, configuration)
      retrieved = Shift4::Charges.retrieve(created['id'], configuration)

      # then
      expect(retrieved['amount']).to eq(charge_req["amount"])
    end
  end

  each_context(*standard_contexts) do
    it 'create and retrieve charge' do
      # given
      charge_req = TestData.charge(card: TestData.card)

      # when
      created = Shift4::Charges.create(charge_req)
      retrieved = Shift4::Charges.retrieve(created['id'])

      # then
      expect(retrieved['amount']).to eq(charge_req["amount"])
      expect(retrieved['currency']).to eq(charge_req["currency"])
      expect(retrieved['description']).to eq(charge_req["description"])
      expect(retrieved['card']['first4']).to eq(charge_req["card"]["first4"])
    end

    it 'create charge only once with idempotency_key' do
      # given
      charge_req = TestData.charge(card: TestData.card)
      request_options = Shift4::RequestOptions.new(idempotency_key: random_idempotency_key.to_s)

      # when
      created = Shift4::Charges.create(charge_req, request_options)
      not_created_because_idempotency = Shift4::Charges.create(charge_req, request_options)

      # then
      expect(created['id']).to eq(not_created_because_idempotency['id'])
      expect(not_created_because_idempotency.headers['Idempotent-Replayed']).to eq("true")
    end

    it 'update charge' do
      # given
      card = TestData.card
      charge_req = TestData.charge(card: card)
      created = Shift4::Charges.create(charge_req)

      # when
      updated = Shift4::Charges.update(created['id'],
                                       "description" => "updated description",
                                       "metadata" => { "key" => "updated value" })

      # then
      expect(created['description']).to eq(charge_req["description"])
      expect(updated['description']).to eq('updated description')

      expect(created['metadata']['key']).to eq(charge_req["metadata"]["key"])
      expect(updated['metadata']['key']).to eq('updated value')

      expect(updated['amount']).to eq(charge_req["amount"])
      expect(updated['currency']).to eq(charge_req["currency"])
      expect(updated['card']['first4']).to eq(charge_req["card"]["first4"])
    end

    it 'update charge only once with idempotency_key' do
      # given
      card = TestData.card
      charge_req = TestData.charge(card: card)
      created = Shift4::Charges.create(charge_req)

      request_options = Shift4::RequestOptions.new(idempotency_key: random_idempotency_key.to_s)

      # when
      updated = Shift4::Charges.update(created['id'],
                                       {
                                         "description" => "updated description",
                                         "metadata" => { "key" => "updated value" }
                                       },
                                       request_options)

      not_updated_because_idempotency = Shift4::Charges.update(created['id'],
                                                               {
                                                                 "description" => "updated description",
                                                                 "metadata" => { "key" => "updated value" }
                                                               },
                                                               request_options)

      # then
      expect(not_updated_because_idempotency.headers['Idempotent-Replayed']).to eq("true")
    end

    it 'capture charge' do
      # given
      charge_req = TestData.charge(card: TestData.card, captured: false)
      created = Shift4::Charges.create(charge_req)

      # when
      captured = Shift4::Charges.capture(created['id'])

      # then
      expect(created['captured']).to eq(false)
      expect(captured['captured']).to eq(true)
    end

    it 'capture charge only once with idempotency_key' do
      # given
      charge_req = TestData.charge(card: TestData.card, captured: false)
      created = Shift4::Charges.create(charge_req)

      request_options = Shift4::RequestOptions.new(idempotency_key: random_idempotency_key.to_s)

      # when
      captured = Shift4::Charges.capture(created['id'], request_options)
      not_captured_because_idempotency = Shift4::Charges.capture(created['id'], request_options)

      # then
      expect(captured['id']).to eq(not_captured_because_idempotency['id'])
      expect(not_captured_because_idempotency.headers['Idempotent-Replayed']).to eq("true")
    end

    it 'refund charge' do
      # given
      charge_req = TestData.charge(card: TestData.card, captured: false)
      created = Shift4::Charges.create(charge_req)

      # when
      refunded = Shift4::Charges.refund(created['id'])

      # then
      expect(created['refunded']).to eq(false)
      expect(refunded['refunded']).to eq(true)
    end

    it 'refund charge only once with idempotency_key' do
      # given
      charge_req = TestData.charge(card: TestData.card, captured: false)
      created = Shift4::Charges.create(charge_req)

      request_options = Shift4::RequestOptions.new(idempotency_key: random_idempotency_key.to_s)

      # when
      refunded = Shift4::Charges.refund(created['id'], nil, request_options)
      not_refunded_because_idempotency = Shift4::Charges.refund(created['id'], nil, request_options)

      # then
      expect(refunded['id']).to eq(not_refunded_because_idempotency['id'])
      expect(not_refunded_because_idempotency.headers['Idempotent-Replayed']).to eq("true")
    end

    it 'list charges' do
      # given
      customer = Shift4::Customers.create(TestData.customer)
      charge_req = TestData.charge(card: TestData.card, customer_id: customer['id'])
      charge1 = Shift4::Charges.create(charge_req)
      charge2 = Shift4::Charges.create(charge_req)
      charge3 = Shift4::Charges.create(charge_req)

      # when
      all_charges = Shift4::Charges.list({ customerId: customer['id'] })
      charges_after_last_id = Shift4::Charges.list({ customerId: customer['id'], startingAfterId: charge3['id'] })

      # then
      expect(all_charges['list'].map { |charge| charge['id'] })
        .to contain_exactly(charge1['id'], charge2['id'], charge3['id'])

      expect(charges_after_last_id['list'].map { |charge| charge['id'] })
        .to contain_exactly(charge1['id'], charge2['id'])
    end
  end
end
