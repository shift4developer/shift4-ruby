# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::Customers do
  each_context(*standard_contexts) do
    it 'create and retrieve customer' do
      # given
      customer_req = TestData.customer

      # when
      created = Shift4::Customers.create(customer_req)
      retrieved = Shift4::Customers.retrieve(created['id'])

      # then
      expect(retrieved['id']).not_to be_nil
      expect(retrieved['email']).to eq(customer_req['email'])
    end

    it 'create only once with idempotency_key' do
      # given
      customer_req = TestData.customer
      request_options = Shift4::RequestOptions.new(idempotency_key: random_idempotency_key.to_s)

      # when
      created = Shift4::Customers.create(customer_req, request_options)
      not_created_because_idempotency = Shift4::Customers.create(customer_req, request_options)

      # then
      expect(created['id']).to eq(not_created_because_idempotency['id'])
      expect(not_created_because_idempotency.headers['Idempotent-Replayed']).to eq("true")
    end

    it 'update customer default card' do
      # given
      customer_req = TestData.customer(card: TestData.card)
      customer = Shift4::Customers.create(customer_req)

      # when
      new_card = Shift4::Cards.create(customer['id'], TestData.card)
      Shift4::Customers.update(customer['id'], { defaultCardId: new_card['id'] })
      updated = Shift4::Customers.retrieve(customer['id'])

      # then
      expect(updated['id']).not_to be_nil
      expect(updated['defaultCardId']).to eq(new_card['id'])
    end

    it 'update customer only once with idempotency_key' do
      # given
      customer_req = TestData.customer(card: TestData.card)
      customer = Shift4::Customers.create(customer_req)
      new_card = Shift4::Cards.create(customer['id'], TestData.card)

      request_options = Shift4::RequestOptions.new(idempotency_key: random_idempotency_key.to_s)

      # when
      updated = Shift4::Customers.update(customer['id'],
                                         { defaultCardId: new_card['id'] },
                                         request_options)
      not_updated_because_idempotency = Shift4::Customers.update(customer['id'],
                                                                 { defaultCardId: new_card['id'] },
                                                                 request_options)

      # then
      expect(not_updated_because_idempotency.headers['Idempotent-Replayed']).to eq("true")
    end

    it 'delete customer' do
      # given
      customer_req = TestData.customer(card: TestData.card)
      customer = Shift4::Customers.create(customer_req)

      # when
      Shift4::Customers.delete(customer['id'])
      updated = Shift4::Customers.retrieve(customer['id'])

      # then
      expect(updated['id']).not_to be_nil
      expect(updated['deleted']).to eq(true)
    end

    it 'list customers' do
      # given
      email = random_email
      customer1 = Shift4::Customers.create(TestData.customer(email: email))
      customer2 = Shift4::Customers.create(TestData.customer(email: email))
      deleted_customer = Shift4::Customers.create(TestData.customer(email: email))
      Shift4::Customers.delete(deleted_customer['id'])

      # when
      all = Shift4::Customers.list(email: email)
      deleted = Shift4::Customers.list(email: email, deleted: true)

      # then
      expect(all['list'].map { |it| it['id'] })
        .to contain_exactly(customer1['id'], customer2['id'])
      expect(deleted['list'].map { |it| it['id'] })
        .to contain_exactly(deleted_customer['id'])
    end
  end
end
