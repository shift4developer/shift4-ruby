# frozen_string_literal: true

RSpec.shared_context 'with test config' do
  before do
    Shift4::Configuration.api_url = ENV.fetch('API_URL', nil)
    Shift4::Configuration.uploads_url = ENV.fetch('UPLOADS_URL', nil)
    Shift4::Configuration.secret_key = ENV.fetch('SECRET_KEY')
  end
end
