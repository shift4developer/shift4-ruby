# frozen_string_literal: true

require_relative '../spec_helper'

describe Shift4::Communicator do
  include_context 'with test config'

  let(:url) { Shift4::Configuration.api_url }

  it 'throw on bad secret key' do
    Shift4::Configuration.secret_key = "sk_not_existing_key"
    expect { Shift4::Communicator.get("#{url}/customers") }
      .to raise_error(Shift4::Shift4Exception) { |error|
        expect(error.response["error"]["type"]).to eq("invalid_request")
        expect(error.response["error"]["message"]).to eq("Provided API key is invalid")
      }
  end

  it 'throw on not found' do
    expect { Shift4::Communicator.get("#{url}/customers/cust_not_existing") }
      .to raise_error(Shift4::Shift4Exception) { |error|
        expect(error.response["error"]["type"]).to eq("invalid_request")
        expect(error.response["error"]["message"]).to eq("Customer 'cust_not_existing' does not exist")
      }
  end

  it 'throw on bad request' do
    expect { Shift4::Communicator.post("#{url}/customers", json: { email: "not an email" }) }
      .to raise_error(Shift4::Shift4Exception) { |error|
        expect(error.response["error"]["type"]).to eq("invalid_request")
        expect(error.response["error"]["message"]).to eq("email: Must be a valid email address.")
      }
  end

  it 'delegate error[] to response[]' do
    expect { Shift4::Communicator.post("#{url}/customers", json: { email: "not an email" }) }
      .to raise_error(Shift4::Shift4Exception) { |error|
        expect(error["error"]["type"]).to eq(error.response["error"]["type"])
        expect(error["error"]["type"]).to eq("invalid_request")
      }
  end

  it 'not throw on correct request' do
    expect { Shift4::Communicator.get("#{url}/customers") }
      .not_to raise_error
  end
end
