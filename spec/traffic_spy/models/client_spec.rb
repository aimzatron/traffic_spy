require 'spec_helper'

describe TrafficSpy::Client do

  before do
    delete_clients
    delete_urls
  end

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

    context "save" do
      it "adds an entry to the clients table" do

        client = described_class.new(identifier:"id", root_url:"url")
        client.save
        expect(clients_table.count).to eq 1

      end
    end

    context "informational methods" do

      def add_dummy_payload values
        default_values =
          { url: "http://jumpstartlab.com/blog",
            requestedAt:"2013-02-16 21:38:28 -0700",
            respondedIn:37,
            referredBy:"http://jumpstartlab.com",
            requestType:"GET",
            parameters:[],
            eventName: "socialLogin",
            userAgent:"Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
            resolutionWidth:"1920",
            resolutionHeight:"1280",
            ip:"63.29.38.211" }

        params = default_values.merge values

        TrafficSpy::Payload.create(params).save
      end

      it "urls returns a collection of urls associated with the identifier, sorted from most visits to least visits" do

        client.save

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

        urls = client.urls
        expect(urls.size).to eq 3
        expect(urls[0].url).to eq "http://jumpstartlab.com/url2"
        expect(urls[1].url).to eq "http://jumpstartlab.com/url1"
        expect(urls[2].url).to eq "http://jumpstartlab.com/url3"

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

    it "finds a client by url" do
      described_class.new(identifier:"ident", root_url:"http://url.com").save
      client = described_class.find_by_root_url "http://url.com"
      expect(client.id).to eq 1
      expect(client.root_url).to eq "http://url.com"
    end
  end

end
