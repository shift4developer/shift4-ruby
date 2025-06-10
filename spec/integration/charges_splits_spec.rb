# frozen_string_literal: true

require_relative '../spec_helper'

split_type = 'tip'
tip_value = 42
platform_merchant = ENV.fetch('MERCHANT')

describe Shift4::ChargeSplits do
  context 'with platform member config' do
    include_context 'with platform member config'

    it 'create and retrieve charge with tip for platform merchant' do
      # given
      charge_req = TestData.charge_with_tip_split(card: TestData.card,
                                                  platform_merchant: platform_merchant,
                                                  tip_value: tip_value)

      # when
      created = Shift4::Charges.create(charge_req)
      retrieved = Shift4::Charges.retrieve(created['id'])

      # then
      expect(retrieved['id']).to eq(created['id'])
      split_info = retrieved['splits'][0]
      expect(split_info['amount']).to eq(tip_value)
      expect(split_info['currency']).to eq(created['currency'])
      expect(split_info['type']).to eq(split_type)
      expect(split_info['merchant']).to eq(platform_merchant)
      expect(split_info['objectType']).to eq('charge_split')
    end
  end

  context 'with platform merchant acting as explicit merchant config' do
    include_context 'with platform merchant acting as explicit merchant config'

    it 'create and retrieve charge with tip for platform merchant' do
      # given
      charge_req = TestData.charge_with_tip_split(card: TestData.card,
                                                  platform_merchant: platform_merchant,
                                                  tip_value: tip_value)

      # when
      created = Shift4::Charges.create(charge_req)
      retrieved = Shift4::Charges.retrieve(created['id'])

      # then
      expect(retrieved['id']).to eq(created['id'])
      split_info = retrieved['splits'][0]
      expect(split_info['amount']).to eq(tip_value)
      expect(split_info['currency']).to eq(created['currency'])
      expect(split_info['type']).to eq(split_type)
      expect(split_info['merchant']).to eq(platform_merchant)
      expect(split_info['objectType']).to eq('charge_split')
    end

    it 'create charge with tip for platform merchant and retrieve charge as explicit merchant' do
      # given
      charge_req = TestData.charge_with_tip_split(card: TestData.card,
                                                  platform_merchant: platform_merchant,
                                                  tip_value: tip_value)

      # when
      created = Shift4::Charges.create(charge_req)
      configuration = Shift4::Configuration.new(
        secret_key: ENV.fetch('EXPLICIT_MERCHANT_SECRET_KEY')
      )
      retrieved = Shift4::Charges.retrieve(created['id'], configuration)

      # then
      expect(retrieved['id']).to eq(created['id'])
      split_info = retrieved['splits'][0]
      expect(split_info['amount']).to eq(tip_value)
      expect(split_info['currency']).to eq(created['currency'])
      expect(split_info['type']).to eq(split_type)
      expect(split_info['merchant']).to eq(platform_merchant)
    end

    it 'create charge with tip and retrieve split info as platform merchant' do
      # given
      charge_req = TestData.charge_with_tip_split(card: TestData.card,
                                                  platform_merchant: platform_merchant,
                                                  tip_value: tip_value)

      # when
      created = Shift4::Charges.create(charge_req)
      created_split_info = created['splits'][0]
      Shift4::Configuration.merchant = nil

      split = Shift4::ChargeSplits.retrieve(created_split_info['id'])

      # then
      expect(split['id']).to eq(created_split_info['id'])
      expect(split['amount']).to eq(tip_value)
      expect(split['currency']).to eq(created['currency'])
      expect(split['type']).to eq(split_type)
      expect(split['merchant']).to eq(platform_merchant)
    end

    it 'create charge with tip and retrieve list of splits as platform merchant' do
      # given
      charge_req = TestData.charge_with_tip_split(card: TestData.card,
                                                  platform_merchant: platform_merchant,
                                                  tip_value: tip_value)

      # when
      created = Shift4::Charges.create(charge_req)
      created_split_info = created['splits'][0]
      configuration = Shift4::Configuration.new(
        secret_key: ENV.fetch('SECRET_KEY'),
        merchant: nil
      )
      splits = Shift4::ChargeSplits.list(nil, configuration)

      # then
      expect(splits['list']).to include(created_split_info)
      expect(splits['list'].size).to satisfy('contains this and historic splits') { |n| n > 1 }
    end

    it 'create charge with tip and retrieve list of splits for specific charge as platform merchant' do
      # given
      charge_req = TestData.charge_with_tip_split(card: TestData.card,
                                                  platform_merchant: platform_merchant,
                                                  tip_value: tip_value)

      # when
      created = Shift4::Charges.create(charge_req)
      created_split_info = created['splits'][0]
      configuration = Shift4::Configuration.new(
        secret_key: ENV.fetch('SECRET_KEY'),
        merchant: nil
      )
      splits = Shift4::ChargeSplits.list({ 'charge' => created['id'] }, configuration)

      # then
      expect(splits['list']).to include(created_split_info)
      expect(splits['list'].size).to satisfy('contains only 1 split for specific charge') { |n| n == 1 }
    end

    it 'create charge with tip and then refund and retrieve it as platform merchant' do
      # given
      charge_req = TestData.charge_with_tip_split(card: TestData.card,
                                                  platform_merchant: platform_merchant,
                                                  tip_value: tip_value)
      created = Shift4::Charges.create(charge_req)
      created_split_info = created['splits'][0]
      refund_request = { 'split' => created_split_info['id'], 'amount' => tip_value }
      configuration = Shift4::Configuration.new(
        secret_key: ENV.fetch('SECRET_KEY'),
        merchant: nil
      )

      # when
      split_refund_created = Shift4::ChargeSplits.refund(refund_request, configuration)
      split_refund_retrieved = Shift4::ChargeSplits.retrieve_refund(split_refund_created['id'], configuration)

      # then
      expect(split_refund_created.body).to eq(split_refund_retrieved.body)
      expect(split_refund_retrieved['amount']).to eq(tip_value)
      expect(split_refund_retrieved['currency']).to eq('EUR')
      expect(split_refund_retrieved['split']).to eq(created_split_info['id'])
      expect(split_refund_retrieved['objectType']).to eq('charge_split_refund')
    end

    it 'create charge with tip and then refund and retrieve list of refunds as platform merchant' do
      # given
      charge_req = TestData.charge_with_tip_split(card: TestData.card,
                                                  platform_merchant: platform_merchant,
                                                  tip_value: tip_value)
      created = Shift4::Charges.create(charge_req)
      created_split_info = created['splits'][0]
      refund_request = { 'split' => created_split_info['id'], 'amount' => tip_value }
      configuration = Shift4::Configuration.new(
        secret_key: ENV.fetch('SECRET_KEY'),
        merchant: nil
      )

      # when
      split_refund_created = Shift4::ChargeSplits.refund(refund_request, configuration)
      split_refunds = Shift4::ChargeSplits.list_refunds(nil, configuration)

      # then
      expect(split_refunds['list']).to include(JSON.parse(split_refund_created.body))
      expect(split_refunds['list'].size).to satisfy('contains this and historic split refunds') { |n| n > 1 }
    end

    it 'create charge with tip and then refund and retrieve list of refunds by specific split as platform merchant' do
      # given
      charge_req = TestData.charge_with_tip_split(card: TestData.card,
                                                  platform_merchant: platform_merchant,
                                                  tip_value: tip_value)
      created = Shift4::Charges.create(charge_req)
      created_split_info = created['splits'][0]
      refund_request = { 'split' => created_split_info['id'], 'amount' => tip_value }
      configuration = Shift4::Configuration.new(
        secret_key: ENV.fetch('SECRET_KEY'),
        merchant: nil
      )

      # when
      split_refund_created = Shift4::ChargeSplits.refund(refund_request, configuration)
      split_refunds = Shift4::ChargeSplits.list_refunds({ 'split' => created_split_info['id'] }, configuration)

      # then
      expect(split_refunds['list']).to include(JSON.parse(split_refund_created.body))
      expect(split_refunds['list'].size).to satisfy('contains this and historic split refunds') { |n| n == 1 }
    end
  end
end
