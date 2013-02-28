require 'spec_helper'

describe TrafficSpy::OperatingSystem do

  before do
    TrafficSpy::DB["DELETE FROM operating_systems"].delete

    @operating_systems_table = TrafficSpy::DB.from(:operating_systems)
  end

  describe "new" do
    it "creates a new entry in the database" do

      operating_system = described_class.new(id: 4, name: "OS")

      expect(operating_system.id).to eq 4
      expect(operating_system.name).to eq "OS"

    end
  end

  describe "instance methods" do

    describe "save" do
      it "adds an entry to the operating systems table" do

        operating_system = described_class.new(id: 4, name: "OS")

        operating_system.save

        expect(@operating_systems_table.count).to eq 1

      end
    end

  end

end
