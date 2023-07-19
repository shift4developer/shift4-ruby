# frozen_string_literal: true

RSpec.shared_context 'with standard config' do
  before do
    Shift4::Configuration.api_url = ENV.fetch('API_URL', nil)
    Shift4::Configuration.uploads_url = ENV.fetch('UPLOADS_URL', nil)
    Shift4::Configuration.secret_key = ENV.fetch('SECRET_KEY')
    Shift4::Configuration.merchant = nil
  end
end

RSpec.shared_context 'with explicit merchant config' do
  before do
    Shift4::Configuration.api_url = ENV.fetch('API_URL', nil)
    Shift4::Configuration.uploads_url = ENV.fetch('UPLOADS_URL', nil)
    Shift4::Configuration.secret_key = ENV.fetch('EXPLICIT_MERCHANT_SECRET_KEY')
    Shift4::Configuration.merchant = ENV.fetch('EXPLICIT_MERCHANT')
  end
end

RSpec.shared_context 'with no secret key in config' do
  before do
    Shift4::Configuration.api_url = ENV.fetch('API_URL', nil)
    Shift4::Configuration.uploads_url = ENV.fetch('UPLOADS_URL', nil)
    Shift4::Configuration.secret_key = nil
    Shift4::Configuration.merchant = nil
  end
end

def standard_contexts
  [
    'with standard config',
    'with explicit merchant config'
  ]
end
