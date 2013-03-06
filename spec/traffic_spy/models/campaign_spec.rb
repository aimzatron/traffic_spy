require 'spec_helper'

describe TrafficSpy::Campaign do

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

        expect(campaigns_table.count).to eq 1

      end
    end
  end

  describe "class methods" do

      before do
        campaigns = described_class.new(id: 1, client_id: 1, name: "Pelican")
        campaigns.save
      end

      it "can find a campaign by id" do
        campaigns = TrafficSpy::Campaign.find_by_id 1
        expect(campaigns.id).to eq 1
        expect(campaigns.client_id).to eq 1
        expect(campaigns.name).to eq "Pelican"
      end

      it "can find a campaign by name" do
        campaigns = TrafficSpy::Campaign.find_by_name "Pelican"
        expect(campaigns.name).to eq "Pelican"
        expect(campaigns.id).to eq 1
        expect(campaigns.client_id).to eq 1
      end
    end

end
