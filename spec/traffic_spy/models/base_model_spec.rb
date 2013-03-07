require 'spec_helper'


describe TrafficSpy::BaseModel do

  before(:all) do

    module TrafficSpy

      class Dummy < BaseModel
        DB.create_table? table_name do
          primary_key :id
          String :name
          String :data
        end

        def initialize params
          super params
        end
      end
    end
  end

  after(:all) do
    TrafficSpy::DB.drop_table tablename
  end

  describe "define find_by methods" do

  let(:described_class) {TrafficSpy::Dummy}

    context "given a table is associated with a model" do

      it "sets the attributes on initialize" do
        dummy = described_class.new(name: "the name", data: "the data")
        expect(dummy.name).to eq "the name"
        expect(dummy.data).to eq "the data"
      end

      it "defines instance methods for getting attributes that match columns" do
        dummy = described_class.new(name: "the name", data: "the data")

        #expect(described_class.id).to eq true
        expect(dummy.methods.include? :id).to eq true
        expect(dummy.methods.include? :name).to eq true
        expect(dummy.methods.include? :data).to eq true
      end

      it "defines find_by for all columns" do
        expect(described_class.methods.include? :find_by_id).to eq true
        expect(described_class.methods.include? :find_by_name).to eq true
        expect(described_class.methods.include? :find_by_data).to eq true
      end

      context "#valid?" do
        it "returns true because all variables except id are set" do
          dummy = described_class.new(name: "the name", data: "the data")
          expect(dummy).to be_valid
        end

        it "returns true because not all variables excluding id" do
          dummy = described_class.new(name: "the name")
          expect(dummy).to_not be_valid
        end
      end

      context "#save" do
        it "implements save" do
          pending
        end
      end


      it "implements find_by for all columns" do
        pending
        dummy = described_class.new name: "the name", data: "the data"

      end



    end
  end

  describe ".attribute" do
  end

end
