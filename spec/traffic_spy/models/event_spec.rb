require 'spec_helper'

describe TrafficSpy::Event do

  before do
    TrafficSpy::DB["DELETE FROM events"].delete

    @event_table = TrafficSpy::DB.from(:events)
  end

  describe "new" do
    it "creates a new entry in the database" do

      pending

    end
  end

end
