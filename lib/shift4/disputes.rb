# frozen_string_literal: true

module Shift4
  class Disputes
    extend TransactionBase

    def self.retrieve(dispute_id, config = Configuration)
      communicator.get("#{config.api_url}/disputes/#{dispute_id}", config: config)
    end

    def self.update(dispute_id, params, config = Configuration, request_options: RequestOptions)
      communicator.post(
        "#{config.api_url}/disputes/#{dispute_id}",
        json: params,
        config: config,
        request_options: request_options
      )
    end

    def self.close(dispute_id, config = Configuration, request_options: RequestOptions)
      communicator.post(
        "#{config.api_url}/disputes/#{dispute_id}/close",
        config: config,
        request_options: request_options
      )
    end

    def self.list(params = nil, config = Configuration)
      communicator.get("#{config.api_url}/disputes", query: params, config: config)
    end
  end
end
