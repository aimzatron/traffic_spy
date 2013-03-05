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

      unless exists?
      id = Payload.data.insert(browser_id: browser_id,
                            event_id: event_id,
                            response_time: response_time,
                            request_time: request_time,
                            url_id: url_id,
                            ip_id: ip_id,
                            screen_resolution_id: screen_resolution_id,
                            os_id: os_id)
      Payload.new Payload.data.where(id: id).first
      end
    end

    def exists?
      Payload.data.where(
        browser_id: browser_id,
        event_id: event_id,
        url_id: url_id,
        ip_id: ip_id,
        screen_resolution_id: screen_resolution_id,
        os_id: os_id,
        response_time: response_time,
        request_time: request_time
      ).count > 0

    end

    def self.create(params)

      client = Client.find_by_root_url params[:referredBy]


      url = get_url params[:url], client
      event = get_event params[:eventName], client

      width = params[:resolutionWidth].to_i
      height = params[:resolutionHeight].to_i
      resolution = get_resolution width, height

      ip = get_ip params[:ip]
      browser = get_browser parse_browser(params[:userAgent])
      os = get_os parse_os(params[:userAgent])


      Payload.new(
        browser_id: browser.id,
        event_id: event.id,
        url_id: url.id,
        ip_id: ip.id,
        screen_resolution_id: resolution.id,
        os_id: os.id,
        response_time: params[:respondedIn].to_i,
        request_time: DateTime.parse(params[:requestedAt]),
      )

    end

    def self.get_url url_string, client
      url = Url.find_by_url url_string
      if url.nil?
        new_url = Url.new client_id: client.id, url: url_string
        url = new_url.save
      end

      url

    end

    def self.get_event event_name, client
      event = Event.find_by name: event_name, client_id: client.id
      if event.nil?
        new_event = Event.new name: event_name, client_id: client.id
        event = new_event.save
      end

      event

    end

    def self.get_resolution width, height

      res = ScreenResolution.find_by_resolution width, height
      if res.nil?
        new_res = ScreenResolution.new width: width, height: height
        res = new_res.save
      end

      res
    end

    def self.get_ip address
      ip = Ip.find_by_address address
      if ip.nil?
        new_ip = Ip.new address: address
        ip = new_ip.save
      end
      ip
    end

    def self.get_browser browser_name
      browser = WebBrowser.find_by_name browser_name
      if browser.nil?
        new_browser = WebBrowser.new name: browser_name
        browser = new_browser.save
      end
      browser
    end

    def self.get_os os_name
      os = OperatingSystem.find_by_name os_name
      if os.nil?
        new_os = OperatingSystem.new name: os_name
        os = new_os.save
      end
      os
    end

    def self.parse_browser userAgent
      userAgent.split.first
    end

    def self.parse_os userAgent
      match = (/[^()]+/.match(/\(.*?\)/.match(userAgent).to_s)).to_s
      match.gsub("%3B", "/")
    end

    def self.data
      DB.from :payloads
    end

    def self.find_by_id id
      Payload.new data.select.where(id: id).first
    end
  end

end
