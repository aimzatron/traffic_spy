require 'spec_helper'

describe TrafficSpy::Client do

  before do
		delete_clients
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
      expect(clients_table.count).to eq 1

      end
    end

    describe "urls" do
      it "returns a collection of urls ordered from most requested to least requested" do
      pending
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
