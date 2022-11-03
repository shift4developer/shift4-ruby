# frozen_string_literal: true

module Shift4
  class FraudWarnings
    extend TransactionBase

    def self.retrieve(fraud_warning_id)
      communicator.get("#{Configuration.api_url}/fraud-warnings/#{fraud_warning_id}")
    end

    def self.list(params = nil)
      communicator.get("#{Configuration.api_url}/fraud-warnings", query: params)
    end
  end
end
