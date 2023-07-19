# frozen_string_literal: true

module Shift4
  class Events
    extend TransactionBase

    def self.retrieve(event_id, config = Configuration)
      communicator.get("#{config.api_url}/events/#{event_id}", config: config)
    end

    def self.list(params = nil, config = Configuration)
      communicator.get("#{config.api_url}/events", query: params, config: config)
    end
  end
end
