# frozen_string_literal: true

module Shift4
  class RequestOptions < Configuration
    class << self
      attr_reader :idempotency_key
    end

    def initialize(
      config = Configuration,
      idempotency_key: nil
    )
      super(
        secret_key: config.secret_key,
        merchant: config.merchant,
        api_url: config.api_url,
        uploads_url: config.uploads_url
      )
      @idempotency_key = idempotency_key
    end

    attr_reader :idempotency_key
  end
end
