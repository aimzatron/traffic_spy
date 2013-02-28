require 'spec_helper'

describe TrafficSpy::Campaign do

  before do
    TrafficSpy::DB["DELETE FROM campaign"].delete

    @campaign_table = TrafficSpy::DB.from(:campaign)
  end

  describe "new" do
    it "creates a new entry in the database" do

      campaign = described_class.new("id", "name", "client_id")

      expect(@campaign_table.count).to eq 1
      expect(@campaign_table.select.where(id: 1).first[:id]).to eq "1"
      expect(@campaign_table.select.where(id: 1).first[:name]).to eq "name"
      expect(@campaign_table.select.where(id: 1).first[:client_id]).to eq "1"

    end
  end

end
