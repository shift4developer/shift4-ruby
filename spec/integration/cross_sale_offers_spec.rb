# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::CrossSaleOffers do
  each_context(*standard_contexts) do
    it 'create and retrieve cross sale offer' do
      # given
      offer_req = TestData.cross_sale_offer_with_charge

      # when
      created = Shift4::CrossSaleOffers.create(offer_req)
      retrieved = Shift4::CrossSaleOffers.retrieve(created['id'])

      # then
      expect(retrieved['id']).not_to be_nil
      expect(retrieved['description']).to eq(offer_req['description'])
      expect(retrieved['title']).to eq(offer_req['title'])
      expect(retrieved['termsAndConditionsUrl']).to eq(offer_req['termsAndConditionsUrl'])
      expect(retrieved['template']).to eq(offer_req['template'])
      expect(retrieved['companyName']).to eq(offer_req['companyName'])
      expect(retrieved['companyLocation']).to eq(offer_req['companyLocation'])
      expect(retrieved['charge']['amount']).to eq(offer_req['charge']['amount'])
      expect(retrieved['charge']['currency']).to eq(offer_req['charge']['currency'])
    end

    it 'update cross sale offer' do
      # given
      offer_req = TestData.cross_sale_offer_with_charge
      created = Shift4::CrossSaleOffers.create(offer_req)

      # when
      updated = Shift4::CrossSaleOffers.update(created['id'],
                                               "description" => "updated description")

      # then
      expect(created['description']).to eq(offer_req["description"])
      expect(updated['description']).to eq('updated description')

      expect(updated['charge']['amount']).to eq(offer_req['charge']['amount'])
    end

    it 'delete cross sale offer' do
      # given
      offer_req = TestData.cross_sale_offer_with_charge

      # when
      created = Shift4::CrossSaleOffers.create(offer_req)
      Shift4::CrossSaleOffers.delete(created['id'])
      updated = Shift4::CrossSaleOffers.retrieve(created['id'])

      # then
      expect(updated['deleted']).to eq(true)
    end

    it 'list cross sale offers' do
      # given
      offer_req = TestData.cross_sale_offer_with_charge
      offer1 = Shift4::CrossSaleOffers.create(offer_req)
      offer2 = Shift4::CrossSaleOffers.create(offer_req)
      offer3 = Shift4::CrossSaleOffers.create(offer_req)

      # when
      all_offers = Shift4::CrossSaleOffers.list(limit: 100)
      offers_after_last_id = Shift4::CrossSaleOffers.list(limit: 100, startingAfterId: offer3['id'])

      # then
      expect(all_offers['list'].map { |offer| offer['id'] })
        .to include(offer1['id'], offer2['id'], offer3['id'])
      expect(offers_after_last_id['list'].map { |offer| offer['id'] })
        .to include(offer1['id'], offer2['id'])
    end
  end
end
