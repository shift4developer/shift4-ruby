# frozen_string_literal: true

require 'httparty'

module Shift4
  class Communicator
    class << self
      attr_accessor :web_consumer
    end

    @web_consumer = HTTParty

    def self.get(url, query: nil, config: Configuration)
      response = web_consumer.get(url, request(query: query, config: config))
      handle_response(response)
      response
    end

    def self.post(url, json: nil, body: nil, config: Configuration)
      response = web_consumer.post(
        url,
        request(json: json, body: body, config: config)
      )
      handle_response(response)
      response
    end

    def self.delete(url, config: Configuration)
      response = web_consumer.delete(url, request(config: config))
      handle_response(response)
      response
    end

    def self.request(json: nil, query: nil, body: nil, config: Configuration)
      headers = {
        "User-Agent" => "Shift4-Ruby/#{Shift4::VERSION} (Ruby/#{RUBY_VERSION})",
        "Accept" => "application/json",
      }
      headers["Shift4-Merchant"] = config.merchant unless config.merchant.nil?
      if config.is_a?(RequestOptions) && !config.idempotency_key.nil?
        headers["Idempotency-Key"] = config.idempotency_key
      end

      if json
        raise ArgumentError("Cannot specify both body and json") if body

        body = json.to_json
        headers["Content-Type"] = "application/json"
      end

      {
        body: body,
        query: query,
        headers: headers,
        basic_auth: {
          username: config.secret_key
        }
      }
    end

    def self.handle_response(response)
      raise Shift4Exception, response if (400..599).cover?(response.code)
    end

    private_class_method :request, :handle_response
  end
end
