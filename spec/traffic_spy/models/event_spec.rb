require 'spec_helper'

describe TrafficSpy::Event do

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

    describe "times_received" do
      it "returns the number of times the event was requested" do

      TrafficSpy::Client.new(identifier: "mock_client", root_url: "http://jumpstartlab.com").save

        add_dummy_payload requestedAt: "2013-02-16 01:38:21 -0700"
        add_dummy_payload requestedAt: "2013-02-16 01:38:22 -0700"
        add_dummy_payload requestedAt: "2013-02-16 01:38:23 -0700"
        add_dummy_payload requestedAt: "2013-02-16 01:38:11 -0700"
        add_dummy_payload requestedAt: "2013-02-16 05:38:21 -0700"
        add_dummy_payload requestedAt: "2013-02-16 14:38:22 -0700"
        add_dummy_payload requestedAt: "2013-02-16 14:38:23 -0700"
        add_dummy_payload eventName: "theOtherEvent"

        event = described_class.find_by name: "socialLogin", client_id: 1

        expect(event.times_received).to eq 7
      end
    end

    describe "request_times" do
      it "returns a hash that breaks down the event request by hour" do

      TrafficSpy::Client.new(identifier: "mock_client", root_url: "http://jumpstartlab.com").save

        add_dummy_payload requestedAt: "2013-02-16 01:38:21 -0700"
        add_dummy_payload requestedAt: "2013-02-16 01:38:22 -0700"
        add_dummy_payload requestedAt: "2013-02-16 01:38:23 -0700"
        add_dummy_payload requestedAt: "2013-02-16 01:38:11 -0700"
        add_dummy_payload requestedAt: "2013-02-16 05:38:21 -0700"
        add_dummy_payload requestedAt: "2013-02-16 14:38:22 -0700"
        add_dummy_payload requestedAt: "2013-02-16 14:38:23 -0700"
        add_dummy_payload eventName: "theOtherEvent"

        event = described_class.find_by name: "socialLogin", client_id: 1

        expected_result = Array.new(24, 0)
        expected_result[1] = 4
        expected_result[5] = 1
        expected_result[14] = 2
        expect(event.request_times).to eq expected_result

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

    it "can find by anything" do
      events = TrafficSpy::Event.find_by name:"Data"
      expect(events.name).to eq "Data"
      expect(events.id).to eq 1
      expect(events.client_id).to eq 1
    end

    it "can find by anything" do
      events = TrafficSpy::Event.find_by id:1
      expect(events.id).to eq 1
      expect(events.name).to eq "Data"
      expect(events.client_id).to eq 1
    end

    context "event exists? given name and client" do

      before do
        TrafficSpy::Client.new(root_url: "blargh", identifier:"wadup").save
      end

      it "exists" do

        exists = described_class.exists_for?("Data", "wadup")
        expect(exists).to eq true
      end

      it "does not exist" do
        exists = described_class.exists_for?("bladlakjdf", "wadup")
        expect(exists).to eq false
      end

      it "is given an identifier that does not exist" do
        exists = described_class.exists_for?("bladlakjdf", "boggle")
        expect(exists).to eq false

      end

    end
  end

end
