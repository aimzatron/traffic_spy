require 'spec_helper'

describe TrafficSpy::ClientsController do

  describe '.create' do

    context 'acceptable params' do

      let(:params) do
        {identifier: "jumpstartlab",
        rootUrl: "http://jumpstartlab.com"}.to_json
      end

      it 'returns a 200 status' do
        pending "finish this test"
        result = described_class.create params
        expect(result.status).to eq 200
      end
    end
  end
end
