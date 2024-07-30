# frozen_string_literal: true

module Shift4
  class Plans
    extend TransactionBase

    def self.create(params, config = Configuration)
      communicator.post("#{config.api_url}/plans", json: params, config: config)
    end

    def self.retrieve(plan_id, config = Configuration)
      communicator.get("#{config.api_url}/plans/#{plan_id}", config: config)
    end

    def self.update(plan_id, params, config = Configuration)
      communicator.post(
        "#{config.api_url}/plans/#{plan_id}",
        json: params,
        config: config
      )
    end

    def self.delete(plan_id, config = Configuration)
      communicator.delete("#{config.api_url}/plans/#{plan_id}", config: config)
    end

    def self.list(params = nil, config = Configuration)
      communicator.get("#{config.api_url}/plans", query: params, config: config)
    end
  end
end
