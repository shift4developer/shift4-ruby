# frozen_string_literal: true

module Shift4
  class Customers
    extend TransactionBase

    def self.create(params, config = Configuration)
      communicator.post(
        "#{config.api_url}/customers",
        json: params, config: config
      )
    end

    def self.retrieve(customer_id, config = Configuration)
      communicator.get("#{config.api_url}/customers/#{customer_id}", config: config)
    end

    def self.update(customer_id, params, config = Configuration)
      communicator.post(
        "#{config.api_url}/customers/#{customer_id}",
        json: params,
        config: config
      )
    end

    def self.delete(customer_id, config = Configuration)
      communicator.delete("#{config.api_url}/customers/#{customer_id}", config: config)
    end

    def self.list(params = nil, config = Configuration)
      communicator.get("#{config.api_url}/customers", query: params, config: config)
    end
  end
end
