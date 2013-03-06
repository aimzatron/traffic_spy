require 'spec_helper'

describe TrafficSpy::ScreenResolution do

  describe "new" do
    it "creates a new entry in the database" do

      screen = described_class.new(width: 1280, height: 800)

      expect(screen.width).to eq 1280
      expect(screen.height).to eq 800

    end
  end

  describe "instance methods" do

    describe "save" do
      it "adds an entry to the screen_resolutions table" do

        screen_resolution = described_class.new(width: 1280, height: 800)

        screen_resolution.save

        expect(screen_resolutions_table.count).to eq 1

      end
    end

  end

  describe "class methods" do
    it "find a screen resolution by dimension" do
      width = 1280
      height = 800

      described_class.new(width: width, height: height).save

      screen = described_class.find_by_resolution width, height
      expect(screen.width).to eq width
      expect(screen.height).to eq height
      expect(screen.id).to eq 1

    end
  end

end
