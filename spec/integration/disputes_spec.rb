# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::Disputes do
  each_context(*standard_contexts) do
    it 'retrieve dispute' do
      # given
      dispute, charge = create_dispute

      # when
      retrieved = Shift4::Disputes.retrieve(dispute['id'])

      # then
      expect(retrieved['charge']['id']).to eq(charge['id'])
    end

    it 'list disputes' do
      # given
      dispute, = create_dispute

      # when
      disputes = Shift4::Disputes.list(limit: 100)

      # then
      expect(disputes['list'].map { |it| it['id'] })
        .to include(dispute['id'])
    end

    it 'update dispute' do
      # given
      dispute, = create_dispute
      evidence_customer_name = 'Test Customer'

      # when
      Shift4::Disputes.update(dispute['id'], { evidence: { customerName: evidence_customer_name } })
      retrieved = Shift4::Disputes.retrieve(dispute['id'])

      # then
      expect(retrieved['evidence']['customerName']).to eq(evidence_customer_name)
    end

    it 'update dispute only once with idempotency_key' do
      # given
      dispute, = create_dispute
      evidence_customer_name = 'Test Customer'

      request_options = Shift4::RequestOptions.new(idempotency_key: random_idempotency_key.to_s)

      # when
      Shift4::Disputes.update(dispute['id'],
                              { evidence: { customerName: evidence_customer_name } },
                              request_options)
      not_updated_because_idempotency = Shift4::Disputes.update(dispute['id'],
                                                                { evidence: { customerName: evidence_customer_name } },
                                                                request_options)

      # then
      expect(not_updated_because_idempotency.headers['Idempotent-Replayed']).to eq("true")
    end

    it 'close dispute' do
      # given
      dispute, = create_dispute

      # when
      Shift4::Disputes.close(dispute['id'])
      retrieved = Shift4::Disputes.retrieve(dispute['id'])

      # then
      expect(retrieved['acceptedAsLost']).to eq(true)
    end

    it 'close dispute only once with idempotency_key' do
      # given
      dispute, = create_dispute

      request_options = Shift4::RequestOptions.new(idempotency_key: random_idempotency_key.to_s)

      # when
      Shift4::Disputes.close(dispute['id'],
                             request_options)
      not_closed_because_idempotency = Shift4::Disputes.close(dispute['id'],
                                                              request_options)

      # then
      expect(not_closed_because_idempotency.headers['Idempotent-Replayed']).to eq("true")
    end
  end
end

def create_dispute
  charge = Shift4::Charges.create(TestData.charge(card: TestData.disputed_card))
  WaitUtil.wait_for_condition("disputed", timeout_sec: 30) do
    Shift4::Charges.retrieve(charge['id'])
                   .fetch('disputed', false)
  end
  disputes = Shift4::Disputes.list(limit: 100)
  dispute = disputes['list'].find { |it| it['charge']['id'] == charge['id'] }
  [dispute, charge]
end
