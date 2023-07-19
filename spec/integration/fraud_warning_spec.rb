# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::FraudWarnings do
  each_context(*standard_contexts) do
    it 'retrieve fraud_warning' do
      # given
      fraud_warning, charge = create_fraud_warning

      # when
      retrieved = Shift4::FraudWarnings.retrieve(fraud_warning['id'])

      # then
      expect(retrieved['charge']).to eq(charge['id'])
    end

    it 'list fraud_warnings' do
      # given
      fraud_warning, = create_fraud_warning

      # when
      fraud_warnings = Shift4::FraudWarnings.list(limit: 100)

      # then
      expect(fraud_warnings['list'].map { |it| it['id'] })
        .to include(fraud_warning['id'])
    end
  end
end

def create_fraud_warning # rubocop:disable Metrics/AbcSize
  charge = Shift4::Charges.create(TestData.charge(card: TestData.fraud_warning_card))
  WaitUtil.wait_for_condition("fraud_warning", timeout_sec: 60) do
    fraud_status = Shift4::Charges.retrieve(charge['id'])
                     &.fetch('fraudDetails', nil)
                     &.fetch('status', nil)
    fraud_status != 'in_progress'
  end
  fraud_warnings = Shift4::FraudWarnings.list(limit: 100)
  fraud_warning = fraud_warnings['list'].find { |it| it['charge'] == charge['id'] }
  raise "#{charge['id']} not found in #{fraud_warnings}" if fraud_warning.nil?

  [fraud_warning, charge]
end
