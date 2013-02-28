require 'spec_helper'

describe TrafficSpy::Campaign do

  before do
    TrafficSpy::DB["DELETE FROM campaigns"].delete

    @campaign_table = TrafficSpy::DB.from(:campaigns)
  end

  describe "new" do
    it "creates a new entry in the database" do

      campaign = described_class.new(name: "name", client_id: 4)

      expect(campaign.name).to eq "name"
      expect(campaign.client_id).to eq 4

    end
  end

  describe "instance methods" do

    describe "save" do
      it "adds an entry to the campaigns table" do

        campaign = described_class.new(name: "name", client_id: 4)

        campaign.save

        expect(@campaign_table.count).to eq 1

      end
    end

  end

end
