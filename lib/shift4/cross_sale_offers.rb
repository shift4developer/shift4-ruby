# frozen_string_literal: true

module Shift4
  class CrossSaleOffers
    extend TransactionBase

    def self.create(params, config = Configuration)
      communicator.post("#{config.api_url}/cross-sale-offers", json: params, config: config)
    end

    def self.retrieve(cross_sale_offer_id, config = Configuration)
      communicator.get("#{config.api_url}/cross-sale-offers/#{cross_sale_offer_id}", config: config)
    end

    def self.update(cross_sale_offer_id, params, config = Configuration)
      communicator.post("#{config.api_url}/cross-sale-offers/#{cross_sale_offer_id}", json: params, config: config)
    end

    def self.delete(cross_sale_offer_id, config = Configuration)
      communicator.delete("#{config.api_url}/cross-sale-offers/#{cross_sale_offer_id}", config: config)
    end

    def self.list(params = nil, config = Configuration)
      communicator.get("#{config.api_url}/cross-sale-offers", query: params, config: config)
    end
  end
end
