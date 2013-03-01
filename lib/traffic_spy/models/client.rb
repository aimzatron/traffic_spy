module TrafficSpy

  class Client
    attr_reader :id, :identifier, :root_url

    def initialize(params)
      @identifier = params[:identifier]
      @root_url = params[:root_url]
    end

    def self.data
      DB.from(:clients)
    end

    def save
      Client.data.insert(identifier: identifier, root_url: root_url)
    end

    def urls
      urls = URL.find_by_client_id id
      #DB.from(:urls).where(client_id:id)
      # SELECT * FROM
      urls.sort_by{|url| url.requests.size}
    end

  end

end
