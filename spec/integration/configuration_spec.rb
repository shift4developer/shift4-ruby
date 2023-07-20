# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::Configuration do
  context "with implicit config" do
    it 'trim trailing slash in urls' do
      Shift4::Configuration.api_url = "http://api.url/"
      Shift4::Configuration.uploads_url = "http://uploads.url/"
      expect(Shift4::Configuration.api_url).to eq("http://api.url")
      expect(Shift4::Configuration.uploads_url).to eq("http://uploads.url")
    end
  end

  context 'with explicit config' do
    it 'trim trailing slash in urls supplied by setter' do
      config = Shift4::Configuration.new(secret_key: "whatever")
      config.api_url = "http://api.url/"
      config.uploads_url = "http://uploads.url/"
      expect(config.api_url).to eq("http://api.url")
      expect(config.uploads_url).to eq("http://uploads.url")
    end

    it 'trim trailing slash in urls supplied by new' do
      config = Shift4::Configuration.new(
        secret_key: "whatever",
        api_url: "http://api.url/",
        uploads_url: "http://uploads.url/"
      )
      expect(config.api_url).to eq("http://api.url")
      expect(config.uploads_url).to eq("http://uploads.url")
    end

    it 'new should create config' do
      # when
      config = Shift4::Configuration.new(
        secret_key: "other_secret",
        api_url: "other_api_url",
        uploads_url: "other_uploads_url",
        merchant: "other_merchant",
      )
      # then
      expect(config.secret_key).to eq("other_secret")
      expect(config.merchant).to eq("other_merchant")
      expect(config.api_url).to eq('other_api_url')
      expect(config.uploads_url).to eq('other_uploads_url')
    end

    it 'new should create config with standard defaults' do
      # given
      Shift4::Configuration.api_url = "some_api_url"
      Shift4::Configuration.secret_key = "some_secret"
      # when
      config = Shift4::Configuration.new(
        secret_key: "other_secret",
      )
      # then
      expect(config.secret_key).to eq("other_secret")
      expect(config.merchant).to be_nil
      expect(config.api_url).to eq('https://api.shift4.com')
      expect(config.uploads_url).to eq('https://uploads.api.shift4.com')
    end

    it 'new should not override defaults from current global config' do
      # given
      Shift4::Configuration.api_url = "some_api_url"
      Shift4::Configuration.uploads_url = "some_uploads_url"
      Shift4::Configuration.merchant = "some_merchant"
      Shift4::Configuration.secret_key = "some_secret"
      # when
      Shift4::Configuration.new(
        secret_key: "other_secret",
        merchant: "other_merchant",
        api_url: "other_api_url",
        uploads_url: "other_uploads_url",
      ).api_url = "dsa"
      # then
      expect(Shift4::Configuration.secret_key).to eq("some_secret")
      expect(Shift4::Configuration.merchant).to eq("some_merchant")
      expect(Shift4::Configuration.api_url).to eq("some_api_url")
      expect(Shift4::Configuration.uploads_url).to eq("some_uploads_url")
    end
  end
end
