# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::Cards do
  each_context(*standard_contexts) do
    it 'create and retrieve card' do
      # given
      customer = Shift4::Customers.create(TestData.customer)
      customer_id = customer['id']
      cardholder_name = random_string

      # when
      created = Shift4::Cards.create(customer_id,
                                     number: '4242424242424242',
                                     expMonth: '12',
                                     expYear: '2055',
                                     cvc: '123',
                                     cardholderName: cardholder_name)
      retrieved = Shift4::Cards.retrieve(customer_id, created['id'])

      # then
      expect(retrieved['last4']).to eq('4242')
      expect(retrieved['expMonth']).to eq('12')
      expect(retrieved['expYear']).to eq('2055')
      expect(retrieved['cardholderName']).to eq(cardholder_name)
      expect(retrieved['customerId']).to eq(customer_id)
    end

    it 'create only one card with idempotency_key' do
      # given
      customer = Shift4::Customers.create(TestData.customer)
      customer_id = customer['id']
      cardholder_name = random_string
      request_options = Shift4::RequestOptions.new(idempotency_key: random_idempotency_key.to_s)

      created = Shift4::Cards.create(customer_id,
                                     {
                                       number: '4242424242424242',
                                       expMonth: '12',
                                       expYear: '2055',
                                       cvc: '123',
                                       cardholderName: cardholder_name
                                     },
                                     request_options)

      # when
      not_created_because_idempotency = Shift4::Cards.create(customer_id,
                                                             {
                                                               number: '4242424242424242',
                                                               expMonth: '12',
                                                               expYear: '2055',
                                                               cvc: '123',
                                                               cardholderName: cardholder_name
                                                             },
                                                             request_options)

      # then
      expect(created['id']).to eq(not_created_because_idempotency['id'])
      expect(not_created_because_idempotency.headers['Idempotent-Replayed']).to eq("true")
    end

    it 'update card' do
      # given
      customer = Shift4::Customers.create(TestData.customer)
      card = Shift4::Cards.create(customer['id'], TestData.card)

      # when
      updated_card = Shift4::Cards.update(customer['id'], card['id'],
                                          expMonth: '05',
                                          expYear: '55',
                                          cardholderName: 'updated cardholderName',
                                          addressCountry: 'updated addressCountry',
                                          addressCity: 'updated addressCity',
                                          addressState: 'updated addressState',
                                          addressZip: 'updated addressZip',
                                          addressLine1: 'updated addressLine1',
                                          addressLine2: 'updated addressLine2')

      # then
      expect(updated_card['expMonth']).to eq('05')
      expect(updated_card['expYear']).to eq('2055')
      expect(updated_card['cardholderName']).to eq('updated cardholderName')
      expect(updated_card['addressCountry']).to eq('updated addressCountry')
      expect(updated_card['addressCity']).to eq('updated addressCity')
      expect(updated_card['addressState']).to eq('updated addressState')
      expect(updated_card['addressZip']).to eq('updated addressZip')
      expect(updated_card['addressLine1']).to eq('updated addressLine1')
      expect(updated_card['addressLine2']).to eq('updated addressLine2')
    end

    it 'update card only once with idempotency_key' do
      # given
      customer = Shift4::Customers.create(TestData.customer)
      card = Shift4::Cards.create(customer['id'], TestData.card)

      request_options = Shift4::RequestOptions.new(idempotency_key: random_idempotency_key.to_s)

      # when
      updated_card = Shift4::Cards.update(customer['id'],
                                          card['id'],
                                          {
                                            expMonth: '05',
                                            expYear: '55',
                                            cardholderName: 'updated cardholderName',
                                            addressCountry: 'updated addressCountry',
                                            addressCity: 'updated addressCity',
                                            addressState: 'updated addressState',
                                            addressZip: 'updated addressZip',
                                            addressLine1: 'updated addressLine1',
                                            addressLine2: 'updated addressLine2'
                                          },
                                          request_options)
      not_updated_because_idempotency = Shift4::Cards.update(customer['id'],
                                                             card['id'],
                                                             {
                                                               expMonth: '05',
                                                               expYear: '55',
                                                               cardholderName: 'updated cardholderName',
                                                               addressCountry: 'updated addressCountry',
                                                               addressCity: 'updated addressCity',
                                                               addressState: 'updated addressState',
                                                               addressZip: 'updated addressZip',
                                                               addressLine1: 'updated addressLine1',
                                                               addressLine2: 'updated addressLine2'
                                                             },
                                                             request_options)

      # then
      expect(not_updated_because_idempotency.headers['Idempotent-Replayed']).to eq("true")
    end

    it 'delete card' do
      # given
      customer = Shift4::Customers.create(TestData.customer)
      card = Shift4::Cards.create(customer['id'], TestData.card)

      # when
      Shift4::Cards.delete(customer['id'], card['id'])
      deleted = Shift4::Cards.retrieve(customer['id'], card['id'])

      # then
      expect(deleted['deleted']).to eq(true)
    end

    it 'list cards' do
      # given
      customer1 = Shift4::Customers.create(TestData.customer)
      customer2 = Shift4::Customers.create(TestData.customer)
      card11 = Shift4::Cards.create(customer1['id'], TestData.card)
      card12 = Shift4::Cards.create(customer1['id'], TestData.card)
      card21 = Shift4::Cards.create(customer2['id'], TestData.card)

      # when
      customer1_cards = Shift4::Cards.list(customer1['id'])
      customer1_cards_limit1 = Shift4::Cards.list(customer1['id'], { limit: 1 })
      customer2_cards = Shift4::Cards.list(customer2['id'])

      # then
      expect(customer1_cards['list'].map { |card| card['id'] })
        .to contain_exactly(card11['id'], card12['id'])
      expect(customer1_cards_limit1['list'].map { |card| card['id'] })
        .to contain_exactly(card12['id'])
      expect(customer2_cards['list'].map { |card| card['id'] })
        .to contain_exactly(card21['id'])
    end
  end
end
