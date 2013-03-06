require 'spec_helper'

describe TrafficSpy::Payload do

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
          userAgent:  "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
          resolutionWidth:  "1920",
          resolutionHeight:  "1280",
          ip:  "63.29.38.211" }
      end

      before do
        clients_table.insert(root_url: "http://jumpstartlab.com",
                             identifier: "blah")
      end

      describe "payload with values not in the database" do
        it "creates a new url object" do

          described_class.create(payload)
          query = urls_table.select.where url: "http://jumpstartlab.com/blog"
          expect(query.to_a).to_not be_empty
        end

        it "creates a new event object" do

          described_class.create(payload)
          query = events_table.select.where name: "socialLogin"
          expect(query.to_a).to_not be_empty
        end

        it "creates a new screen resolution object" do

          described_class.create(payload)
          query = screen_resolutions_table.select.where width: 1920, height: 1280
          expect(query.to_a).to_not be_empty
        end

        it "creates a new ip object" do

          described_class.create(payload)
          query = ips_table.select.where address: "63.29.38.211"
          expect(query.to_a).to_not be_empty
        end

        it "adds a new entry to the web_browser table" do

          described_class.create(payload)
          query = web_browsers_table.select.where name: "Mozilla/5.0"
          expect(query.to_a).to_not be_empty
        end

        it "adds a new entry to the operating_systems table" do
          os_name = "Macintosh/ Intel Mac OS X 10_8_2"

          described_class.create(payload)
          query = operating_systems_table.select.where name: os_name

          expect(query.to_a).to_not be_empty
        end
      end

      describe "payload with values already in the database" do
        it "doesn't create a new url object" do

          urls_table.insert(client_id: 1, url: "http://jumpstartlab.com/blog" )

          described_class.create(payload)
          query = urls_table.select.where url: "http://jumpstartlab.com/blog"
          expect(query.count).to eq 1
        end

        it "doesn't create a new event object" do
          events_table.insert(client_id: 1, name: "socialLogin" )

          described_class.create(payload)
          query = events_table.select.where name: "socialLogin"
          expect(query.count).to eq 1
        end

        it "doesn't create a new screen resolution object" do
          screen_resolutions_table.insert(width: 1920, height: 1280 )

          described_class.create(payload)
          query = screen_resolutions_table.select.where width: 1920, height: 1280
          expect(query.count).to eq 1
        end

        it "doesn't create a new ip object" do
          ips_table.insert(address: "63.29.38.211")

          described_class.create(payload)
          query = ips_table.select.where address: "63.29.38.211"
          expect(query.count).to eq 1
        end

        it "doesn't add new entry to the web_browser table" do
          web_browsers_table.insert(name: "Mozilla/5.0")

          described_class.create(payload)
          query = web_browsers_table.select.where name: "Mozilla/5.0"
          expect(query.count).to eq 1
        end

        it "doesn't add new entry to the operating_systems table" do
          os_name = "Macintosh/ Intel Mac OS X 10_8_2"
          operating_systems_table.insert(name: os_name)

          described_class.create(payload)
          query = operating_systems_table.select.where name: os_name
          expect(query.count).to eq 1
        end
      end

      it "has the right attributes" do
        new_payload = described_class.create(payload)

        request_time = DateTime.parse payload[:requestedAt]

        expect(new_payload.browser_id).to eq 1
        expect(new_payload.event_id).to eq 1
        expect(new_payload.response_time).to eq 37
        expect(new_payload.request_time).to eq request_time
        expect(new_payload.url_id).to eq 1
        expect(new_payload.ip_id).to eq 1
        expect(new_payload.screen_resolution_id).to eq 1
        expect(new_payload.os_id).to eq 1
      end

      it "doesn't save a payload that already exists" do
        described_class.create(payload).save
        second_payload = described_class.create(payload)
        expect(second_payload.save).to be_nil
      end

      it "save a new payload" do
        new_payload = described_class.create(payload)


        request_time = DateTime.parse payload[:requestedAt]

        expect(new_payload.browser_id).to eq 1
        expect(new_payload.event_id).to eq 1
        expect(new_payload.response_time).to eq 37
        expect(new_payload.request_time).to eq request_time
        expect(new_payload.url_id).to eq 1
        expect(new_payload.ip_id).to eq 1
        expect(new_payload.screen_resolution_id).to eq 1
        expect(new_payload.os_id).to eq 1
      end
    end
  end

end
