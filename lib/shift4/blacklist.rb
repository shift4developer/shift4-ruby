# frozen_string_literal: true

module Shift4
  # Blacklist can be used to block unwanted charges.
  class Blacklist
    extend TransactionBase

    def self.create(params, config = Configuration)
      communicator.post("#{config.api_url}/blacklist", json: params, config: config)
    end

    def self.retrieve(blacklist_rule_id, config = Configuration)
      communicator.get("#{config.api_url}/blacklist/#{blacklist_rule_id}", config: config)
    end

    def self.delete(blacklist_rule_id, config = Configuration)
      communicator.delete("#{config.api_url}/blacklist/#{blacklist_rule_id}", config: config)
    end

    def self.list(params = nil, config = Configuration)
      communicator.get("#{config.api_url}/blacklist", query: params, config: config)
    end
  end
end
