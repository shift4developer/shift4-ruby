# frozen_string_literal: true

module Shift4
  class Cards
    extend TransactionBase

    def self.create(customer_id, params, config = Configuration, request_options: RequestOptions)
      communicator.post(
        "#{config.api_url}/customers/#{customer_id}/cards",
        json: params,
        config: config,
        request_options: request_options
      )
    end

    def self.retrieve(customer_id, card_id, config = Configuration)
      communicator.get("#{config.api_url}/customers/#{customer_id}/cards/#{card_id}", config: config)
    end

    def self.update(customer_id, card_id, params, config = Configuration, request_options: RequestOptions)
      communicator.post(
        "#{config.api_url}/customers/#{customer_id}/cards/#{card_id}",
        json: params,
        config: config,
        request_options: request_options
      )
    end

    def self.delete(customer_id, card_id, config = Configuration)
      communicator.delete("#{config.api_url}/customers/#{customer_id}/cards/#{card_id}", config: config)
    end

    def self.list(customer_id, params = nil, config = Configuration)
      communicator.get("#{config.api_url}/customers/#{customer_id}/cards", query: params, config: config)
    end
  end
end
