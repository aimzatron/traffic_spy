require 'spec_helper'

describe TrafficSpy::Payload do

  before do
    delete_payloads
    delete_clients
    delete_urls
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
  describe "find all by url"
    it "finds all by url" do

      payloads = described_class.new(browser_id: 1, 
                                      event_id: 1, 
                                      response_time: 1, 
                                      request_time: 1, 
                                      url_id: 1, 
                                      ip_id: 1, 
                                      screen_resolution_id: 1, 
                                      os_id: 1)
      payloads.save

      payloads = described_class.new(browser_id: 1, 
                                      event_id: 1, 
                                      response_time: 1, 
                                      request_time: 1, 
                                      url_id: 1, 
                                      ip_id: 1, 
                                      screen_resolution_id: 1, 
                                      os_id: 1)
      payloads.save

      payloads = described_class.new(browser_id: 1, 
                                      event_id: 1, 
                                      response_time: 1, 
                                      request_time: 1, 
                                      url_id: 2, 
                                      ip_id: 1, 
                                      screen_resolution_id: 1, 
                                      os_id: 1)
      payloads.save

      # expect(described_class.find_all_by_url_id(1).count).to eq 2
      # expect(described_class.find_all_by_url_id(1))
      pending
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

        expect(payloads_table.count).to eq 1

      end
    end

    describe "create payload" do

      let(:payload) do 
        { url: "http://jumpstartlab.com/blog",
          requestedAt: "2013-02-16 21:38:28 -0700",
          respondedIn:  37,
          referredBy:  "http://jumpstartlab.com",
          requestType:  "GET",
          parameters:  [],
          eventName:  "socialLogin",
          userAgent:  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
          resolutionWidth:  "1920",
          resolutionHeight:  "1280",
          ip:  "63.29.38.211" } 
        end

      it "creates a new url object" do

        clients_table.insert(root_url: "http://jumpstartlab.com",
          identifier: "blah")


          described_class.create(payload)
          query = urls_table.select.where url: "http://jumpstartlab.com/blog"
          expect(query.to_a).to_not be_empty

          #new_payload = TrafficSpy::Payload.find_by_id 1
      end

      it "creates a new url object" do

        clients_table.insert(root_url: "http://jumpstartlab.com",
          identifier: "blah")
        urls_table.insert(client_id: 1, url: "http://jumpstartlab.com/blog" )
        
          described_class.create(payload)
          query = urls_table.select.where url: "http://jumpstartlab.com/blog"
          expect(query.to_a.size).to eq 1

          #new_payload = TrafficSpy::Payload.find_by_id 1
      end
    end
  end

end
