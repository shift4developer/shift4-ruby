# frozen_string_literal: true

module Shift4
  class Charges
    extend TransactionBase

    def self.create(params, config = Configuration, request_options: RequestOptions)
      communicator.post("#{config.api_url}/charges", json: params, config: config, request_options: request_options)
    end

    def self.retrieve(charge_id, config = Configuration)
      communicator.get("#{config.api_url}/charges/#{charge_id}", config: config)
    end

    def self.update(charge_id, params, config = Configuration, request_options: RequestOptions)
      communicator.post(
        "#{config.api_url}/charges/#{charge_id}",
        json: params,
        config: config,
        request_options: request_options
      )
    end

    def self.list(params = nil, config = Configuration)
      communicator.get("#{config.api_url}/charges", query: params, config: config)
    end

    def self.capture(charge_id, config = Configuration, request_options: RequestOptions)
      communicator.post(
        "#{config.api_url}/charges/#{charge_id}/capture",
        config: config,
        request_options: request_options
      )
    end

    def self.refund(charge_id, params = nil, config = Configuration, request_options: RequestOptions)
      communicator.post(
        "#{config.api_url}/charges/#{charge_id}/refund",
        json: params,
        config: config,
        request_options: request_options
      )
    end
  end
end
