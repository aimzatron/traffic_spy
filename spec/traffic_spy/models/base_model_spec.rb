require 'spec_helper'

def create_table

  TrafficSpy::DB.create_table? :dummys do
    primary_key :id
    String :name
    String :info
  end
end

describe TrafficSpy::BaseModel do

  before(:all) do
    create_table

    module TrafficSpy
      class Dummy < BaseModel
      end
    end

  end

  after(:all) do
    TrafficSpy::DB.drop_table table_name
  end

  describe "define find_by methods" do

  let(:described_class) {TrafficSpy::Dummy}

    context "given a table is associated with a model" do

      it "sets the attributes on initialize" do
        dummy = described_class.new(name: "the name", info: "the data")
        expect(dummy.name).to eq "the name"
        expect(dummy.info).to eq "the data"
      end

      it "defines instance methods for getting attributes that match columns" do
        dummy = described_class.new(name: "the name", info: "the data")

        #expect(described_class.id).to eq true
        expect(dummy.methods.include? :id).to eq true
        expect(dummy.methods.include? :name).to eq true
        expect(dummy.methods.include? :info).to eq true
      end

      it "defines find_by for all columns" do
        expect(described_class.methods.include? :find_by_id).to eq true
        expect(described_class.methods.include? :find_by_name).to eq true
        expect(described_class.methods.include? :find_by_info).to eq true
      end

      context "#valid?" do
        it "returns true because all variables and possibly id are set" do
          dummy = described_class.new(name: "the name", info: "the data")
          expect(dummy).to be_valid
        end

        it "returns false because not all variables excluding id" do
          dummy = described_class.new(name: "the name")
          expect(dummy).to_not be_valid
        end
      end

      context "#invalid?" do
        it "returns false because all variables and possibly id are set" do
          dummy = described_class.new(name: "the name", info: "the data")
          expect(dummy).to_not be_invalid
        end

        it "returns true because not all variables excluding id" do
          dummy = described_class.new(name: "the name")
          expect(dummy).to be_invalid
        end
      end

      context "#exists?" do
        it "returns true when an object in the table with the same id exists" do
          dummy = described_class.new(name: "the name", info: "the data")
          dummy.save
          expect(dummy).to be_exists
        end

        it "returns false when an object in the table with the same id doesnt exist" do
          dummy = described_class.new(name: "the name", info: "the data")
          expect(dummy).to_not be_exists
        end

      end

      context "#save" do
        it "sets the id after save" do
          dummy = described_class.new(name: "the name", info: "the data")
          dummy.save
          expect(dummy.id).to_not be_nil
        end

        it "saves a valid client" do
          dummy = described_class.new(name: "the name", info: "the data")
          dummy.save
          expect(dummy.id).to eq 1
        end

        it "doesn't save a valid client" do
          dummy = described_class.new(name: "the name")
          expect{dummy.save}.to raise_error(ArgumentError)
        end

        it "doesn't save a client that exists" do
          dummy = described_class.new(name: "the name", info: "the data")
          dummy.save
          expect{dummy.save}.to raise_error(ArgumentError)
        end

      end

      it "compares models by their value" do
        dummy1 = described_class.new(id: 1, name: "a name", info: "the data")
        dummy2 = described_class.new(id: 1, name: "a name", info: "the data")
        expect(dummy1).to eq dummy2
      end

      it "compares models by their value" do
        dummy1 = described_class.new(id: 2, name: "a name", info: "the data")
        dummy2 = described_class.new(id: 1, name: "a name", info: "the data")
        expect(dummy1).to_not eq dummy2
      end

      it "implements find_by for all columns" do
        dummy1 = described_class.new name: "the name", info: "the data"
        dummy1.save
        dummy2 = described_class.new name: "the name2", info: "the data2"
        dummy2.save

        dummy = described_class.find_by_id dummy1.id
        expect(dummy).to eq dummy1
      end

    end
  end

end
