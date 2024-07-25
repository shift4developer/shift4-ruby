# frozen_string_literal: true

module Shift4
  class Subscriptions
    extend TransactionBase

    def self.create(params, config = Configuration, request_options: RequestOptions)
      communicator.post(
        "#{config.api_url}/subscriptions",
        json: params,
        config: config,
        request_options: request_options
      )
    end

    def self.retrieve(subscription_id, config = Configuration)
      communicator.get("#{config.api_url}/subscriptions/#{subscription_id}", config: config)
    end

    def self.update(subscription_id, params, config = Configuration, request_options: RequestOptions)
      communicator.post(
        "#{config.api_url}/subscriptions/#{subscription_id}",
        json: params,
        config: config,
        request_options: request_options
      )
    end

    def self.cancel(subscription_id, config = Configuration)
      communicator.delete("#{config.api_url}/subscriptions/#{subscription_id}", config: config)
    end

    def self.list(params = nil, config = Configuration)
      communicator.get("#{config.api_url}/subscriptions", query: params, config: config)
    end
  end
end
