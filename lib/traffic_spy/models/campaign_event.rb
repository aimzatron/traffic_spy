module TrafficSpy

  class CampaignEvent
    attr_reader :campaign_id, :event_id

    def initialize(params)
      @campaign_id = params[:campaign_id]
      @event_id = params[:client_id]

    end

    def save
      CampaignEvent.data.insert(campaign_id: campaign_id, event_id: event_id)
    end

    def self.data
      DB.from :campaign_events
    end
  end

end
