require 'spec_helper'

describe TrafficSpy::Client do

  before do
    TrafficSpy::DB["DELETE FROM clients"].delete

    @client_table = TrafficSpy::DB.from(:clients)
  end

  describe "new" do
    it "creates a new entry in the database" do

      client = described_class.new("id", "url")

      expect(@client_table.count).to eq 1
      expect(@client_table.select.where(id: 1).first[:identifier]).to eq "id"
      expect(@client_table.select.where(id: 1).first[:root_url]).to eq "url"

    end
  end

end
