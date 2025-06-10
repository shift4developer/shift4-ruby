# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::Tokens do
  each_context(*standard_contexts) do
    it 'create and retrieve token' do
      # given
      token_req = TestData.card

      # when
      token = Shift4::Tokens.create(token_req)
      retrieved = Shift4::Tokens.retrieve(token['id'])

      # then
      expect(retrieved['last4']).to eq(token_req['number'][-4, 4])
      expect(retrieved['first6']).to eq(token_req['number'][0, 6])
      expect(retrieved['expMonth']).to eq(token_req['expMonth'])
      expect(retrieved['expYear']).to eq("20#{token_req['expYear']}")
      expect(retrieved['cardholderName']).to eq(token_req['cardholderName'])
      expect(retrieved['customerId']).to eq(token_req['customerId'])
      expect(retrieved['used']).to be(false)
    end
  end
end
