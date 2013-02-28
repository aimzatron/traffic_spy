require 'spec_helper'

describe TrafficSpy::Url do

  before do
    TrafficSpy::DB["DELETE FROM url"].delete

    @url_table = TrafficSpy::DB.from(:url)
  end

  describe "new" do
    it "creates a new entry in the database" do

      url = described_class.new("id", "url")

      expect(@url_table.count).to eq 1
      expect(@url_table.select.where(id: 1).first[:identifier]).to eq "id"
      expect(@url_table.select.where(id: 1).first[:url]).to eq "url"
      expect(@url_table.select.where(id: 1).first[:client_id]).to eq "1"

    end
  end

end
