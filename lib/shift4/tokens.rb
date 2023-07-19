# frozen_string_literal: true

module Shift4
  class Tokens
    extend TransactionBase

    def self.create(params, config = Configuration)
      communicator.post("#{config.api_url}/tokens", json: params, config: config)
    end

    def self.retrieve(token_id, config = Configuration)
      communicator.get("#{config.api_url}/tokens/#{token_id}", config: config)
    end
  end
end
