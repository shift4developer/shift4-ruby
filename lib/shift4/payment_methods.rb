# frozen_string_literal: true

module Shift4
  class PaymentMethods
    extend TransactionBase

    def self.create(params, config = Configuration, request_options: RequestOptions)
      communicator.post(
        "#{config.api_url}/payment-methods",
        json: params,
        config: config,
        request_options: request_options
      )
    end

    def self.retrieve(plan_id, config = Configuration)
      communicator.get("#{config.api_url}/payment-methods/#{plan_id}", config: config)
    end

    def self.delete(plan_id, config = Configuration)
      communicator.delete("#{config.api_url}/payment-methods/#{plan_id}", config: config)
    end

    def self.list(params = nil, config = Configuration)
      communicator.get("#{config.api_url}/payment-methods", query: params, config: config)
    end
  end
end
