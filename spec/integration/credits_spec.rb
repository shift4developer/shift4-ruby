# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::Credits do
  each_context(*standard_contexts) do
    it 'create and retrieve credit' do
      # given
      credit_req = TestData.credit(card: TestData.card)

      # when
      created = Shift4::Credits.create(credit_req)
      retrieved = Shift4::Credits.retrieve(created['id'])

      # then
      expect(retrieved['amount']).to eq(credit_req["amount"])
      expect(retrieved['currency']).to eq(credit_req["currency"])
      expect(retrieved['description']).to eq(credit_req["description"])
      expect(retrieved['card']['first4']).to eq(credit_req["card"]["first4"])
    end

    it 'update credit' do
      # given
      card = TestData.card
      credit_req = TestData.credit(card: card)

      # when
      created = Shift4::Credits.create(credit_req)
      updated = Shift4::Credits.update(created['id'],
                                       "description" => "updated description",
                                       "metadata" => { "key" => "updated value" })

      # then
      expect(created['description']).to eq(credit_req["description"])
      expect(updated['description']).to eq('updated description')

      expect(created['metadata']['key']).to eq(credit_req["metadata"]["key"])
      expect(updated['metadata']['key']).to eq('updated value')

      expect(updated['amount']).to eq(credit_req["amount"])
      expect(updated['currency']).to eq(credit_req["currency"])
      expect(updated['card']['first4']).to eq(credit_req["card"]["first4"])
    end

    it 'list credits' do
      # given
      customer = Shift4::Customers.create(TestData.customer)
      credit_req = TestData.credit(card: TestData.card, customer_id: customer['id'])
      credit1 = Shift4::Credits.create(credit_req)
      credit2 = Shift4::Credits.create(credit_req)
      credit3 = Shift4::Credits.create(credit_req)

      # when
      all_credits = Shift4::Credits.list({ customerId: customer['id'] })
      credits_after_last_id = Shift4::Credits.list({ customerId: customer['id'], startingAfterId: credit3['id'] })

      # then
      expect(all_credits['list'].map { |credit| credit['id'] })
        .to contain_exactly(credit1['id'], credit2['id'], credit3['id'])

      expect(credits_after_last_id['list'].map { |credit| credit['id'] })
        .to contain_exactly(credit1['id'], credit2['id'])
    end
  end
end
