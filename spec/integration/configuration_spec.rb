# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::Communicator do
  it 'trim trailing slash in api_url' do
    Shift4::Configuration.api_url = "http://ddsadsa.dsadas/"
    expect(Shift4::Configuration.api_url).to eq("http://ddsadsa.dsadas")
  end

  it 'trim trailing slash in uploads_url' do
    Shift4::Configuration.uploads_url = "http://ddsadsa.dsadas/"
    expect(Shift4::Configuration.uploads_url).to eq("http://ddsadsa.dsadas")
  end
end
