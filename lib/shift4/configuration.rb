# frozen_string_literal: true

module Shift4
  class Configuration
    class << self
      attr_accessor :secret_key
      attr_reader :api_url, :uploads_url
    end

    @api_url = 'https://api.shift4.com'
    @uploads_url = 'https://uploads.api.shift4.com'

    def self.api_url=(api_url)
      @api_url = if api_url.nil?
                   'https://api.shift4.com'
                 else
                   api_url.gsub(%r{/$}, "")
                 end
    end

    def self.uploads_url=(uploads_url)
      @uploads_url = if uploads_url.nil?
                       'https://uploads.api.shift4.com'
                     else
                       uploads_url.gsub(%r{/$}, "")
                     end
    end
  end
end
