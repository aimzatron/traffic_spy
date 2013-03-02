module TrafficSpy

  class Payload
    attr_reader :browser_id, 
                :event_id, 
                :response_time, 
                :request_time, 
                :url_id, 
                :ip_id, 
                :screen_resolution_id, 
                :os_id,
                :id

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

    def self.create(params)

      url_string = params[:url]

      url = Url.find_by_url url_string

      if url.nil?
        puts "URL does not exist in table. creating a new url"
        client = Client.find_by_root_url params[:referredBy]
        new_url = Url.new client_id: client.id, url: url_string
        new_url = new_url.save
      else
        puts "Url exists!"
        #just grab the id
      end

    end

    def self.data
      DB.from :payloads
    end

    def self.find_by_id id
      Payload.new data.select.where(id: id).to_a.first
    end
  end

end
