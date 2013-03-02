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

       client = Client.find_by_root_url params[:referredBy]


      url_string = params[:url]

      url = Url.find_by_url url_string

      if url.nil?
        new_url = Url.new client_id: client.id, url: url_string
        new_url = new_url.save
      else
        puts "Url exists!"
      end

      event_string = params[:eventName]

      event = Event.find_by name: event_string, client_id: client.id

      if event.nil?
        new_event = Event.new name: event_string, client_id: client.id
        new_event = new_event.save
      else
        puts "Event exists!"
      end

      width = params[:resolutionWidth].to_i
      height = params[:resolutionHeight].to_i

      res = ScreenResolution.find_by_resolution width, height

      if res.nil?
        new_res = ScreenResolution.new width: width, height: height
        new_res = new_res.save
      else
        puts "Resolution exists!"
      end

      address = params[:ip]
      puts address
      
      ip = Ip.find_by_address address

      if ip.nil?
        new_ip = Ip.new address: address
        new_ip = new_ip.save
      else
        puts "Ip exists!"
      end


    end

    def self.data
      DB.from :payloads
    end

    def self.find_by_id id
      Payload.new data.select.where(id: id).first
    end
  end

end
