require 'spec_helper'

describe TrafficSpy::CampaignEvent do

  before do
    TrafficSpy::DB["DELETE FROM campaign_events"].delete

    @campaign_events_table = TrafficSpy::DB.from(:campaign_events)
  end

  describe "new" do
    it "creates a new entry in the database" do

      campaign_events = described_class.new(campaign_id: 4, event_id: 4)

      expect(campaign_events.campaign_id).to eq 4
      expect(campaign_events.event_id).to eq 4

    end
  end

  describe "instance methods" do

    describe "save" do
      it "adds an entry to the campaign_events table" do

        campaign_events = described_class.new(campaign_id: 4, event_id: 4

        campaign_events.save

        expect(@campaign_events_table.count).to eq 1

      end
    end

  end

end
