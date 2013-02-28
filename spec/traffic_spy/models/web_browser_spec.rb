
require 'spec_helper'

describe TrafficSpy::WebBrowser do

  before do
    TrafficSpy::DB["DELETE FROM web_browsers"].delete

    @web_browser_table = TrafficSpy::DB.from(:web_browsers)
  end

  describe "new" do
    it "creates a new entry in the database" do

      web_browser = described_class.new(name: "chrome")

      expect(web_browser.name).to eq "chrome"

    end
  end

  describe "instance methods" do

    describe "save" do
      it "adds an entry to the web_browsers table" do

        web_browser = described_class.new(name: "chrome")

        web_browser.save

        expect(@web_browser_table.count).to eq 1

      end
    end

  end

end
