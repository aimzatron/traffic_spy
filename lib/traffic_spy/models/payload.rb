module TrafficSpy

  class Payload
    attr_reader :browser_id, 
                :event_id, 
                :response_time, 
                :request_time, 
                :url_id, 
                :ip_id, 
                :screen_resolution_id, 
                :os_id

    def initialize(params)
      @browser_id = params[:browser_id]
      @event_id = params[:event_id]
      @response_time = params[:response_time]
      @request_time = params[:request_time]
      @url_id = params[:url_id]
      @ip_id = params[:ip_id]
      @screen_resolution_id = params[:screen_resolution_id]
      @os_id = params[:os_id]
    end

    def save
      Payload.data.insert(browser_id: browser_id, 
                            event_id: event_id, 
                            response_time: response_time, 
                            request_time: request_time, 
                            url_id: url_id, 
                            ip_id: ip_id, 
                            screen_resolution_id: screen_resolution_id, 
                            os_id: os_id)
    end

    def self.data
      DB.from :payloads
    end
  end

end
