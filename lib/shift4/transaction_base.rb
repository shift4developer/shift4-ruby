# frozen_string_literal: true

module Shift4
  module TransactionBase
    def communicator
      @communicator ||= Communicator
    end

    def communicator=(value)
      @communicator = value
    end
  end
end
