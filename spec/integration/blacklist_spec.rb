# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::Blacklist do
  include_context 'with test config'

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
