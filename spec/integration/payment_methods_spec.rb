# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::PaymentMethods do
  each_context(*standard_contexts) do
    it 'create and retrieve payment_method' do
      # given
      payment_method_req = TestData.payment_method

      # when
      created = Shift4::PaymentMethods.create(payment_method_req)
      retrieved = Shift4::PaymentMethods.retrieve(created['id'])

      # then
      expect(retrieved['id']).to eq(created['id'])
      expect(retrieved['clientObjectId']).to eq(created['clientObjectId'])
      expect(retrieved['type']).to eq(payment_method_req['type'])
      expect(retrieved['billing']).to eq(payment_method_req['billing'])
      expect(retrieved['status']).to eq('chargeable')
      expect(retrieved['status']).to eq('chargeable')
    end

    it 'create only once with idempotency_key' do
      # given
      payment_method_req = TestData.payment_method
      request_options = Shift4::RequestOptions.new(idempotency_key: random_idempotency_key.to_s)

      # when
      created = Shift4::PaymentMethods.create(payment_method_req, request_options)
      not_created_because_idempotency = Shift4::PaymentMethods.create(payment_method_req,
                                                                      request_options)

      # then
      expect(created['id']).to eq(not_created_because_idempotency['id'])
      expect(not_created_because_idempotency.headers['Idempotent-Replayed']).to eq("true")
    end

    it 'delete payment_method' do
      # given
      payment_method_req = TestData.payment_method
      created = Shift4::PaymentMethods.create(payment_method_req)

      # when
      Shift4::PaymentMethods.delete(created['id'])
      retrieved = Shift4::PaymentMethods.retrieve(created['id'])

      # then
      expect(retrieved['id']).to eq(created['id'])
      expect(retrieved['deleted']).to be(true)
    end

    it 'list payment_methods' do
      # given
      customer = Shift4::Customers.create(TestData.customer)
      payment_method_req = TestData.payment_method(customer_id: customer['id'])
      payment_method1 = Shift4::PaymentMethods.create(payment_method_req)
      payment_method2 = Shift4::PaymentMethods.create(payment_method_req)
      payment_method3 = Shift4::PaymentMethods.create(payment_method_req)

      # when
      all_payment_methods = Shift4::PaymentMethods.list({ customerId: customer['id'] })
      payment_methods_after_last_id = Shift4::PaymentMethods.list(
        { customerId: customer['id'], startingAfterId: payment_method3['id'] }
      )

      # then
      expect(all_payment_methods['list'].map { |payment_method| payment_method['id'] })
        .to contain_exactly(payment_method1['id'], payment_method2['id'], payment_method3['id'])

      expect(payment_methods_after_last_id['list'].map { |payment_method| payment_method['id'] })
        .to contain_exactly(payment_method1['id'], payment_method2['id'])
    end
  end
end
