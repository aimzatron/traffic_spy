require 'spec_helper'

describe TrafficSpy::Payload do

  before do
    delete_payloads
    delete_clients
    delete_urls
    delete_events
    delete_screen_resolutions
    delete_ips
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

        before do
          clients_table.insert(root_url: "http://jumpstartlab.com",
          identifier: "blah")
        end

      it "creates a new url object" do

          described_class.create(payload)
          query = urls_table.select.where url: "http://jumpstartlab.com/blog"
          expect(query.to_a).to_not be_empty

          #new_payload = TrafficSpy::Payload.find_by_id 1
      end

      it "doesn't create a new url object" do

        urls_table.insert(client_id: 1, url: "http://jumpstartlab.com/blog" )
        
          described_class.create(payload)
          query = urls_table.select.where url: "http://jumpstartlab.com/blog"
          expect(query.to_a.size).to eq 1

          #new_payload = TrafficSpy::Payload.find_by_id 1
      end

      it "creates a new event object" do

        described_class.create(payload)
        query = events_table.select.where name: "socialLogin"
        expect(query.to_a).to_not be_empty
      end

      it "doesn't create a new event object" do
        events_table.insert(client_id: 1, name: "socialLogin" )

        described_class.create(payload)
        query = events_table.select.where name: "socialLogin"
        expect(query.to_a.size).to eq 1
      end

      it "creates a new screen resolution object" do

        described_class.create(payload)
        query = screen_resolutions_table.select.where width: 1920, height: 1280
        expect(query.to_a).to_not be_empty
      end

      it "doesn't create a new screen resolution object" do
        screen_resolutions_table.insert(width: 1920, height: 1280 )

        described_class.create(payload)
        query = screen_resolutions_table.select.where width: 1920, height: 1280
        expect(query.to_a.size).to eq 1
      end

      it "creates a new ip object" do

        described_class.create(payload)
        puts ips_table.to_a
        query = ips_table.select.where address: "63.29.38.211"
        expect(query.to_a).to_not be_empty
      end

      it "doesn't create a new ip object" do
        ips_table.insert(address: "63.29.38.211")

        described_class.create(payload)
        query = ips_table.select.where address: "63.29.38.211"
        expect(query.to_a.size).to eq 1
      end

      it "creates a new web_browser object" do

        described_class.create(payload)
        puts ips_table.to_a
        query = ips_table.select.where 
        pending
        #expect(query.to_a).to_not be_empty
      end

      it "doesn't create a new web_browser object" do
        ips_table.insert(address: "63.29.38.211")

        described_class.create(payload)
        query = ips_table.select.where address: "63.29.38.211"
        pending
        #expect(query.to_a.size).to eq 1
      end

    end
  end

end
