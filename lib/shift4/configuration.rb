# frozen_string_literal: true

module Shift4
  class Configuration
    class << self
      attr_accessor :secret_key, :merchant
      attr_reader :api_url, :uploads_url

      @api_url = 'https://api.shift4.com'
      @uploads_url = 'https://uploads.api.shift4.com'

      def api_url=(api_url)
        @api_url = api_url.nil? ? 'https://api.shift4.com' : api_url.gsub(%r{/$}, "")
      end

      def uploads_url=(uploads_url)
        @uploads_url = uploads_url.nil? ? 'https://uploads.api.shift4.com' : uploads_url.gsub(%r{/$}, "")
      end
    end

    attr_accessor :secret_key, :merchant
    attr_reader :api_url, :uploads_url

    def initialize(
      secret_key:,
      merchant: nil,
      api_url: 'https://api.shift4.com',
      uploads_url: 'https://uploads.api.shift4.com'
    )
      self.api_url = api_url
      self.uploads_url = uploads_url
      self.secret_key = secret_key
      self.merchant = merchant
    end

    def api_url=(api_url)
      @api_url = api_url.nil? ? 'https://api.shift4.com' : api_url.gsub(%r{/$}, "")
    end

    def uploads_url=(uploads_url)
      @uploads_url = uploads_url.nil? ? 'https://uploads.api.shift4.com' : uploads_url.gsub(%r{/$}, "")
    end
  end
end
