# frozen_string_literal: true

module Shift4
  class RequestOptions
    class << self
      attr_reader :idempotency_key
    end

    def initialize(params = {})
      @idempotency_key = params.fetch(:idempotency_key, nil)
    end

    attr_reader :idempotency_key
  end
end
