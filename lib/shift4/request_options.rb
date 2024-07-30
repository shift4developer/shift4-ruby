# frozen_string_literal: true

module Shift4
  class RequestOptions
    class << self
      attr_reader :idempotency_key
    end

    def initialize(idempotency_key: nil)
      @idempotency_key = idempotency_key
    end

    attr_reader :idempotency_key
  end
end
