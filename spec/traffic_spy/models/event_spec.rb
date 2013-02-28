require 'spec_helper'

describe TrafficSpy::Event do

  before do
    TrafficSpy::DB["DELETE FROM event"].delete

    @event_table = TrafficSpy::DB.from(:event)
  end

  describe "new" do
    it "creates a new entry in the database" do

      event = described_class.new("id", "name", "client_id")

      expect(@event_table.count).to eq 1
      expect(@event_table.select.where(id: 1).first[:id]).to eq "1"
      expect(@event_table.select.where(id: 1).first[:name]).to eq "name"
      expect(@event_table.select.where(id: 1).first[:client_id]).to eq "1"

    end
  end

end
