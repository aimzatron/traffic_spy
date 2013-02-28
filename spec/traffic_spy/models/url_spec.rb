require 'spec_helper'

describe TrafficSpy::Url do

  before do
    TrafficSpy::DB["DELETE FROM urls"].delete

    @url_table = TrafficSpy::DB.from(:urls)
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

        expect(@url_table.count).to eq 1

      end
    end

  end

end
