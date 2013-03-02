require 'spec_helper'

describe TrafficSpy::Url do

  before do
    delete_urls
  end

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
