require 'spec_helper'

describe TrafficSpy::Url do

  describe "new" do
    it "creates a new entry in the database" do

      url = described_class.new(url: "url", client_id: 4)

      expect(url.url).to eq "url"
      expect(url.client_id).to eq 4

    end
  end

  describe "instance methods" do

    describe "save" do
      it "adds an entry to the urls table" do

        url = described_class.new(url: "url", client_id: 4)

        url.save

        expect(urls_table.count).to eq 1

      end
    end

    describe "response times" do

      before do
        TrafficSpy::Client.new(identifier: "client",
                               root_url:"http://jumpstartlab.com").save

        add_dummy_payload respondedIn: 20, url: "url"
        add_dummy_payload respondedIn: 10, url: "url"
        add_dummy_payload respondedIn: 30, url: "url"
        add_dummy_payload respondedIn: 40, url: "url1"

      end

      let(:url) { described_class.find_by_id 1 }

      it "returns a descending list of response times" do
        times = url.response_times

        expect(times.size).to eq  3
        expect(times[0]).to eq 30
        expect(times[1]).to eq 20
        expect(times[2]).to eq 10
      end

      it "returns the average response time of the url" do
        expect(url.average_response_time).to eq 20
      end
    end

  end

  describe "class methods" do

    before do
      url = described_class.new(client_id:1, url: "http://url.com")
      url.save
    end

    it "can find a URL by id" do
      url = TrafficSpy::Url.find_by_id 1
      expect(url.url).to eq "http://url.com"
      expect(url.client_id).to eq 1
    end

    it "can find a URL by url" do
      url = TrafficSpy::Url.find_by_url "http://url.com"
      expect(url.url).to eq "http://url.com"
      expect(url.client_id).to eq 1
    end

  end

end
