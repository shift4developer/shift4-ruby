# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::Plans do
  each_context(*standard_contexts) do
    it 'create and retrieve plan' do
      # given
      plan_req = TestData.plan

      # when
      created = Shift4::Plans.create(plan_req)
      retrieved = Shift4::Plans.retrieve(created['id'])

      # then
      expect(retrieved['id']).to eq(created['id'])
      expect(retrieved['amount']).to eq(plan_req['amount'])
      expect(retrieved['currency']).to eq(plan_req['currency'])
      expect(retrieved['interval']).to eq(plan_req['interval'])
      expect(retrieved['name']).to eq(plan_req['name'])
    end

    it 'update plan' do
      # given
      plan_req = TestData.plan
      created = Shift4::Plans.create(plan_req)

      # when
      Shift4::Plans.update(created['id'], { amount: 222, currency: 'PLN', name: 'Updated plan' })
      retrieved = Shift4::Plans.retrieve(created['id'])

      # then
      expect(retrieved['id']).to eq(created['id'])
      expect(retrieved['interval']).to eq(plan_req['interval'])
      expect(retrieved['amount']).to eq(222)
      expect(retrieved['currency']).to eq('PLN')
      expect(retrieved['name']).to eq('Updated plan')
    end

    it 'delete plan' do
      # given
      plan_req = TestData.plan
      created = Shift4::Plans.create(plan_req)

      # when
      Shift4::Plans.delete(created['id'])
      retrieved = Shift4::Plans.retrieve(created['id'])

      # then
      expect(retrieved['id']).to eq(created['id'])
      expect(retrieved['deleted']).to eq(true)
    end

    it 'list plans' do
      # given
      plan1 = Shift4::Plans.create(TestData.plan)
      plan2 = Shift4::Plans.create(TestData.plan)
      deleted_plan = Shift4::Plans.create(TestData.plan)
      Shift4::Plans.delete(deleted_plan['id'])

      # when
      all = Shift4::Plans.list(limit: 100)
      deleted = Shift4::Plans.list(limit: 100, deleted: true)

      # then
      expect(all['list'].map { |it| it['id'] })
        .to include(plan1['id'], plan2['id'])
      expect(deleted['list'].map { |it| it['id'] })
        .to include(deleted_plan['id'])
    end
  end
end
