require 'spec_helper'

describe TrafficSpy::Event do

  before do
		delete_events
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

        expect(events_table.count).to eq 1

      end
    end
  end

    describe "class methods" do

      before do
        events = described_class.new(id: 1, client_id: 1, name: "Data")
        events.save
      end

      it "can find an event by id" do
        events = TrafficSpy::Event.find_by_id 1
        expect(events.id).to eq 1
        expect(events.client_id).to eq 1
        expect(events.name).to eq "Data"
      end

      it "can find an event by name" do
        events = TrafficSpy::Event.find_by_name "Data"
        expect(events.name).to eq "Data"
        expect(events.id).to eq 1
        expect(events.client_id).to eq 1
      end
    end

end
