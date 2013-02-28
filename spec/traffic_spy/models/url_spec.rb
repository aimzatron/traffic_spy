require 'spec_helper'

describe TrafficSpy::Url do

  before do
    TrafficSpy::DB["DELETE FROM urls"].delete

    @url_table = TrafficSpy::DB.from(:urls)
  end

  describe "new" do
    it "creates a new entry in the database" do
      pending

    end
  end

end
