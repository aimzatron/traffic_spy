require 'spec_helper'

describe TrafficSpy::Client do

  before do
    TrafficSpy::DB["DELETE FROM clients"].delete

    @client_table = TrafficSpy::DB.from(:clients)
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

    describe "save" do
      it "adds an entry to the clients table" do

      client = described_class.new(identifier:"id", root_url:"url")
      client.save
      expect(@client_table.count).to eq 1

      end
    end

  end


end
