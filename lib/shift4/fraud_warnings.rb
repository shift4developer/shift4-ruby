# frozen_string_literal: true

module Shift4
  class FraudWarnings
    extend TransactionBase

    def self.retrieve(fraud_warning_id, config = Configuration)
      communicator.get("#{config.api_url}/fraud-warnings/#{fraud_warning_id}", config: config)
    end

    def self.list(params = nil, config = Configuration)
      communicator.get("#{config.api_url}/fraud-warnings", query: params, config: config)
    end
  end
end
