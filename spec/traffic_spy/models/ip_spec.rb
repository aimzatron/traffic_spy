
require 'spec_helper'

describe TrafficSpy::Ip do

  before do
		delete_ips
  end

  describe "new" do
    it "creates a new entry in the database" do

      ip = described_class.new(address: "123.456.123.123")

      expect(ip.address).to eq "123.456.123.123"

    end
  end

  describe "instance methods" do

    describe "save" do
      it "adds an entry to the ip table" do

        ip = described_class.new(address: "123.456.123.123")

        ip.save

        expect(ips_table.count).to eq 1

      end
    end
  end

    describe "class methods" do

      before do
        ips = described_class.new(id: 1, address: "127.127.1.1")
        ips.save
      end

      it "can find an ip by id" do
        ips = TrafficSpy::Ip.find_by_id 1
        expect(ips.id).to eq 1
        expect(ips.address).to eq "127.127.1.1"
      end

      it "can find an ip by address" do
        ips = TrafficSpy::Ip.find_by_address "127.127.1.1"
        expect(ips.address).to eq "127.127.1.1"
        expect(ips.id).to eq 1
      end
    end

end
