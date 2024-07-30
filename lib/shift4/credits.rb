# frozen_string_literal: true

module Shift4
  class Credits
    extend TransactionBase

    def self.create(params, config = Configuration)
      communicator.post("#{config.api_url}/credits", json: params, config: config, )
    end

    def self.retrieve(credit_id, config = Configuration)
      communicator.get("#{config.api_url}/credits/#{credit_id}", config: config)
    end

    def self.update(credit_id, params, config = Configuration)
      communicator.post(
        "#{config.api_url}/credits/#{credit_id}",
        json: params,
        config: config
      )
    end

    def self.list(params = nil, config = Configuration)
      communicator.get("#{config.api_url}/credits", query: params, config: config)
    end
  end
end
