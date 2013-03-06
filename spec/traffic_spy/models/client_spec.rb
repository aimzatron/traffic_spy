require 'spec_helper'

describe TrafficSpy::Client do

  describe "new" do
    it "creates a new client" do

      client = described_class.new(identifier:"id", root_url:"url")
      expect(client.id).to be_nil
      expect(client.identifier).to eq "id"
      expect(client.root_url).to eq "url"

    end
  end

  describe "Instance methods" do

    let(:client) do
      described_class.new identifier: "mock_client", root_url: "http://jumpstartlab.com"
    end

    let(:client2) do
      described_class.new identifier: "mock_client2", root_url: "http://jumpstartlab2.com"
    end

    context "save" do
      it "adds an entry to the clients table" do

        client = described_class.new(identifier:"id", root_url:"url")
        client.save
        expect(clients_table.count).to eq 1

      end
    end

    context "informational methods" do

      it "returns a collection of events associated with the identifier" do

        saved_client = client.save
        client2.save

        add_dummy_payload(eventName: "event1")
        add_dummy_payload(eventName: "event1",
                          respondedIn: 2)
        add_dummy_payload(eventName: "event2")
        add_dummy_payload(eventName: "event2",
                          respondedIn: 2)
        add_dummy_payload(eventName: "event3",
                          respondedIn: 2,
                          referredBy: "http://jumpstartlab2.com")

        events = saved_client.events
        expect(events.size).to eq 2
        events.each do |event|
          match = /event[12]/.match(event.name)
          expect(match.to_a).to_not be_empty
        end

      end

      it "returns a collection of urls associated with the identifier, sorted from most visits to least visits" do

        saved_client = client.save
        client2.save

        add_dummy_payload(url: "http://jumpstartlab.com/url1",
                          respondedIn: 1)
        add_dummy_payload(url: "http://jumpstartlab.com/url1",
                          respondedIn: 2)
        add_dummy_payload(url: "http://jumpstartlab.com/url2",
                          respondedIn: 3)
        add_dummy_payload(url: "http://jumpstartlab.com/url2",
                          respondedIn: 4)
        add_dummy_payload(url: "http://jumpstartlab.com/url2",
                          respondedIn: 5)
        add_dummy_payload(url: "http://jumpstartlab.com/url3",
                          respondedIn: 5)
        add_dummy_payload(url: "http://jumpstartlab2.com/url3",
                          referredBy: "http://jumpstartlab2.com",
                          respondedIn: 5)
        add_dummy_payload(url: "http://jumpstartlab2.com/url2",
                          referredBy: "http://jumpstartlab2.com",
                          respondedIn: 5)

        urls = saved_client.urls
        expect(urls.size).to eq 3
        expect(urls[0].url).to eq "http://jumpstartlab.com/url2"
        expect(urls[1].url).to eq "http://jumpstartlab.com/url1"
        expect(urls[2].url).to eq "http://jumpstartlab.com/url3"
      end

      it "returns web browser breakdown across all requests" do
        saved_client = client.save
        client2.save

        add_dummy_payload(url: "http://jumpstartlab.com/url1",
                          respondedIn: 2,
                          userAgent:"chrome (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
        add_dummy_payload(url: "http://jumpstartlab.com/url2",
                          respondedIn: 2,
                          userAgent:"chrome (windows) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")

        add_dummy_payload(url: "http://jumpstartlab.com/url1",
                          respondedIn: 3,
                          userAgent:"chrome (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
        add_dummy_payload(url: "http://jumpstartlab.com/url2",
                          respondedIn: 3,
                          userAgent:"chrome (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
        add_dummy_payload(url: "http://jumpstartlab.com/url1",
                          respondedIn: 2,
                          userAgent:"safari (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
        add_dummy_payload(url: "http://jumpstartlab.com/url1",
                          respondedIn: 3,
                          userAgent:"safari (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
        add_dummy_payload(url: "http://jumpstartlab2.com/url1",
                          referredBy: "http://jumpstartlab2.com",
                          respondedIn: 3,
                          userAgent:"safari (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")

        browsers = saved_client.web_browsers
        expect(browsers.size).to eq 2

        expect(browsers["chrome"]).to eq 4
        expect(browsers["safari"]).to eq 2
      end

      it "returns operating system breakdown across all requests" do
        saved_client = client.save
        client2.save

        add_dummy_payload(url: "http://jumpstartlab.com/url1",
                          respondedIn: 2,
                          userAgent:"chrome (mac) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
        add_dummy_payload(url: "http://jumpstartlab.com/url2",
                          respondedIn: 2,
                          userAgent:"chrome (windows) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")

        add_dummy_payload(url: "http://jumpstartlab.com/url1",
                          respondedIn: 3,
                          userAgent:"chrome (mac) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
        add_dummy_payload(url: "http://jumpstartlab.com/url2",
                          respondedIn: 3,
                          userAgent:"chrome (windows) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
        add_dummy_payload(url: "http://jumpstartlab.com/url1",
                          respondedIn: 2,
                          userAgent:"safari (mac) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
        add_dummy_payload(url: "http://jumpstartlab.com/url1",
                          respondedIn: 3,
                          userAgent:"safari (linux) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")
        add_dummy_payload(url: "http://jumpstartlab2.com/url1",
                          referredBy: "http://jumpstartlab2.com",
                          respondedIn: 3,
                          userAgent:"safari (windows) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17")

        os = saved_client.operating_systems
        expect(os.size).to eq 3

        expect(os["mac"]).to eq 3
        expect(os["windows"]).to eq 2
        expect(os["linux"]).to eq 1
      end

      it "returns screen resolution breakdown across all requests" do
        saved_client = client.save

        add_dummy_payload(respondedIn: "1920",
                          resolutionHeight: "1280")
        add_dummy_payload(resolutionWidth: "100",
                          resolutionHeight: "200",
                          url: "http://jumpstartlab.com/url1")
        add_dummy_payload(resolutionWidth: "100",
                          resolutionHeight: "200",
                          respondedIn:1,
                          url: "http://jumpstartlab.com/url1")
        add_dummy_payload(resolutionWidth: "1680",
                          resolutionHeight: "1520")
        add_dummy_payload(resolutionWidth: "1680",
                          resolutionHeight: "1520",
                          url: "http://jumpstartlab.com/url1")

        screen_resolution = saved_client.screen_resolutions
        expect(screen_resolution.size).to eq 3
        expect(screen_resolution["1920x1280"]).to eq 1
        expect(screen_resolution["1680x1520"]).to eq 2
        expect(screen_resolution["100x200"]).to eq 2
      end

    end

  end

  describe "Class methods" do

    it "finds a client by identifier" do
      described_class.new(identifier:"ident", root_url:"http://url.com").save
      client = described_class.find_by_identifier "ident"
      expect(client.id).to eq 1
      expect(client.root_url).to eq "http://url.com"
    end

    it "finds a client by identifier" do
      described_class.new(identifier:"ident", root_url:"http://url.com").save
      client = described_class.find_by_id 1
      expect(client.identifier).to eq  "ident"
      expect(client.root_url).to eq "http://url.com"
    end

    it "finds a client by url" do
      described_class.new(identifier:"ident", root_url:"http://url.com").save
      client = described_class.find_by_root_url "http://url.com"
      expect(client.id).to eq 1
      expect(client.root_url).to eq "http://url.com"
    end

    context "client exists? given identifier" do

      it "exists" do
        described_class.new(identifier:"ident", root_url:"http://url.com").save
        expect(described_class.exists? "ident").to eq true
      end

      it "doest not exist" do
        expect(described_class.exists? "ident").to eq false
      end
    end
  end

end
