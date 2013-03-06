
require 'spec_helper'

describe TrafficSpy::WebBrowser do

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

        expect(web_browsers_table.count).to eq 1

      end
    end
 end

  describe "class methods" do

    before do
      web_browser = described_class.new(id:1, name: "Chrome")
      web_browser.save
    end

    it "can find a web_browser by id" do
      web_browser = TrafficSpy::WebBrowser.find_by_id 1
      expect(web_browser.id).to eq 1
      expect(web_browser.name).to eq "Chrome"
    end

    it "can find a web_browser by name" do
      web_browser = TrafficSpy::WebBrowser.find_by_name "Chrome"
      expect(web_browser.name).to eq "Chrome"
      expect(web_browser.id).to eq 1
    end
  end

end
