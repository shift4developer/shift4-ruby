# frozen_string_literal: true

module Shift4
  class ChargeSplits
    extend TransactionBase

    def self.retrieve(split_id, config = Configuration)
      communicator.get("#{config.api_url}/charge-splits/#{split_id}", config: config)
    end

    def self.list(params, config = Configuration)
      communicator.get("#{config.api_url}/charge-splits", query: params, config: config)
    end

    def self.refund(params, config = Configuration)
      communicator.post("#{config.api_url}/charge-split-refunds", json: params, config: config)
    end

    def self.retrieve_refund(split_refund_id, config = Configuration)
      communicator.get("#{config.api_url}/charge-split-refunds/#{split_refund_id}", config: config)
    end

    def self.list_refunds(params, config = Configuration)
      communicator.get("#{config.api_url}/charge-split-refunds", query: params, config: config)
    end
  end
end
