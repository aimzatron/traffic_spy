require 'spec_helper'

describe TrafficSpy::ScreenResolution do

  before do
    TrafficSpy::DB["DELETE FROM screen_resolutions"].delete

    @url_table = TrafficSpy::DB.from(:screen_resolutions)
  end

  describe "new" do
    it "creates a new entry in the database" do

      url = described_class.new(width: 1280, height: 800)

      expect(screen_resolution.width).to eq 1280
      expect(screen_resolution.height).to eq 800

    end
  end

  describe "instance methods" do

    describe "save" do
      it "adds an entry to the screen_resolutions table" do

        screen_resolution = described_class.new(width: 1280, height: 800)

        screen_resolution.save

        expect(@screen_resolutions_table.count).to eq 1

      end
    end

  end

end
