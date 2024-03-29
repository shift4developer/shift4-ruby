# frozen_string_literal: true

require 'dotenv/load'
require 'simplecov'
require 'waitutil'

require_relative '../lib/shift4'

require_relative 'support/common_context'
require_relative 'support/context_helper'
require_relative 'support/random_data'
require_relative 'support/test_data'
require_relative 'support/matchers'

SimpleCov.start

RSpec.configure do |config|
  config.color = true
end
