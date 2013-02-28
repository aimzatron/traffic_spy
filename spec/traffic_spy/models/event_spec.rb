require 'spec_helper'

describe TrafficSpy::Event do

  before do
    TrafficSpy::DB["DELETE FROM events"].delete

    @event_table = TrafficSpy::DB.from(:events)
  end

  describe "new" do
    it "creates a new entry in the database" do

      event = described_class.new(name: "name", client_id: 4)

      expect(event.name).to eq "name"
      expect(event.client_id).to eq 4

    end
  end

  describe "instance methods" do

    describe "save" do
      it "adds an entry to the events table" do

        event = described_class.new(name: "name", client_id: 4)

        event.save

        expect(@event_table.count).to eq 1

      end
    end

  end

end
