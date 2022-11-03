# frozen_string_literal: true

module  Shift4
  class Shift4Exception < StandardError
    attr_reader :response

    def initialize(response)
      super(response)
      @response = response
    end

    def [](key)
      response[key]
    end
  end
end
