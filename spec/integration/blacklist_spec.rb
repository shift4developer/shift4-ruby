# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::Blacklist do
  each_context(*standard_contexts) do
    it 'create and retrieve blacklist' do
      # given
      email = random_email
      # when
      created = Shift4::Blacklist.create({ ruleType: 'email', email: email, })
      retrieved = Shift4::Blacklist.retrieve(created['id'])

      # then
      expect(retrieved['ruleType']).to eq('email')
      expect(retrieved['email']).to eq(email)
    end

    it 'create only one rule on blacklist with idempotency_key' do
      # given
      email = random_email
      request = { ruleType: 'email', email: email, }

      request_options = Shift4::RequestOptions.new(idempotency_key: random_idempotency_key.to_s)

      # when
      created = Shift4::Blacklist.create(
        request,
        request_options: request_options
      )
      not_created_because_idempotency = Shift4::Blacklist.create(
        request,
        request_options: request_options
      )

      # then
      expect(created['id']).to eq(not_created_because_idempotency['id'])
      expect(not_created_because_idempotency.headers['Idempotent-Replayed']).to eq("true")
    end

    it 'delete blacklist' do
      # given
      email = random_email
      # given
      created = Shift4::Blacklist.create({ ruleType: 'email', email: email, })

      # when
      Shift4::Blacklist.delete(created['id'])
      deleted = Shift4::Blacklist.retrieve(created['id'])

      # then
      expect(deleted['ruleType']).to eq('email')
      expect(deleted['email']).to eq(email)
      expect(deleted['deleted']).to eq(true)
    end

    it 'list blacklist' do
      # given
      created1 = Shift4::Blacklist.create({ ruleType: 'email', email: random_email })
      created2 = Shift4::Blacklist.create({ ruleType: 'email', email: random_email })
      deleted = Shift4::Blacklist.create({ ruleType: 'email', email: random_email })
      Shift4::Blacklist.delete(deleted['id'])

      # when
      all_default = Shift4::Blacklist.list(limit: 100)
      all_with_deleted = Shift4::Blacklist.list(deleted: true, limit: 100)

      # then
      expect(all_default['list'].map { |it| it['id'] })
        .to include(created1['id'], created2['id'])
        .and not_include(deleted['id'])
      expect(all_with_deleted['list'].map { |it| it['id'] })
        .to include(deleted['id'])
        .and not_include(created1['id'], created2['id'])
    end
  end
end
