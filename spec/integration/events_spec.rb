# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::Events do
  each_context(*standard_contexts) do
    it 'retrieve event' do
      # given
      event, charge = create_event

      # when
      retrieved = Shift4::Events.retrieve(event['id'])

      # then
      expect(retrieved['data']['id']).to eq(charge['id'])
    end

    it 'list events' do
      # given
      event, = create_event

      # when
      events = Shift4::Events.list(limit: 100)

      # then
      expect(events['list'].map { |it| it['id'] })
        .to include(event['id'])
    end
  end

  def create_event
    charge = Shift4::Charges.create(TestData.charge(card: TestData.fraud_warning_card))
    events = Shift4::Events.list(limit: 100)
    event = events['list'].find { |it| it['data']['id'] == charge['id'] }
    [event, charge]
  end
end
