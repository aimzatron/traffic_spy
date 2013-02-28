require 'spec_helper'

describe TrafficSpy::Url do

  before do
    TrafficSpy::DB["DELETE FROM operating systems"].delete

    @operating_systems_table = TrafficSpy::DB.from(:operating_systems)
  end

  describe "new" do
    it "creates a new entry in the database" do

      operating_systems = described_class.new(id: 4, name: "OS")

      expect(operating_systems.id).to eq 4
      expect(operating_systems.name).to eq "OS"

    end
  end

  describe "instance methods" do

    describe "save" do
      it "adds an entry to the operating systems table" do

        operating_systems = described_class.new(id: 4, name: "OS")

        operating_systems.save

        expect(@operating_systems_table.count).to eq 1

      end
    end

  end

end
