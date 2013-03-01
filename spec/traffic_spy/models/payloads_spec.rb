require 'spec_helper'

describe TrafficSpy::Payload do

  before do
    TrafficSpy::DB["DELETE FROM payloads"].delete

    @payloads_table = TrafficSpy::DB.from(:payloads)
  end

  describe "new" do
    it "creates a new entry in the database" do

      payloads = described_class.new(browser_id: 1, 
                                      event_id: 1, 
                                      response_time: 1, 
                                      request_time: 1, 
                                      url_id: 1, 
                                      ip_id: 1, 
                                      screen_resolution_id: 1, 
                                      os_id: 1)

      expect(payloads.browser_id).to eq 1
      expect(payloads.event_id).to eq 1
      expect(payloads.response_time).to eq 1
      expect(payloads.request_time).to eq 1
      expect(payloads.url_id).to eq 1
      expect(payloads.ip_id).to eq 1
      expect(payloads.screen_resolution_id).to eq 1
      expect(payloads.os_id).to eq 1

    end
  end

  describe "instance methods" do

    describe "save" do
      it "adds an entry to the payloads table" do

        payloads = described_class.new(browser_id: 1, 
                                      event_id: 1, 
                                      response_time: 1, 
                                      request_time: 1, 
                                      url_id: 1, 
                                      ip_id: 1, 
                                      screen_resolution_id: 1, 
                                      os_id: 1)

        payloads.save

        expect(@payloads_table.count).to eq 1

      end
    end

  end

end

#:browser_id, :event_id, :response_time, :request_time, :url_id, :ip_id, :screen_resolution_id, :os_id
