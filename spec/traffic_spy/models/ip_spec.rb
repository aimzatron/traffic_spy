
require 'spec_helper'

describe TrafficSpy::Ip do

  before do
    TrafficSpy::DB["DELETE FROM ips"].delete

    @ips_table = TrafficSpy::DB.from(:ips)
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

        expect(@ips_table.count).to eq 1

      end
    end

  end

end
