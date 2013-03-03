require 'spec_helper'

describe TrafficSpy::OperatingSystem do

  before do
    delete_operating_systems
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

        expect(operating_systems_table.count).to eq 1

      end
    end

  end

  describe "class methods" do
    before do
      operating_systems_table.insert(name: "os_name")
    end

    context "find" do
      it "finds an operating system by name" do
        os = described_class.find_by_name("os_name")

        expect(os.name).to eq "os_name"
        expect(os.id).to eq 1
      end

      it "finds an operating system by id" do
        os = described_class.find_by_id(1)

        expect(os.name).to eq "os_name"
        expect(os.id).to eq 1
      end
    end
  end

end
