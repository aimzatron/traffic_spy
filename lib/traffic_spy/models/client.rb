module TrafficSpy

  class Client
    attr_reader :id, :identifier, :root_url

    def initialize(params)
      @id = params[:id]
      @identifier = params[:identifier]
      @root_url = params[:root_url]
    end

    def self.data
      DB.from(:clients)
    end

    def save
      id = Client.data.insert(identifier: identifier, root_url: root_url)
      Client.new Client.data.where(id:id).first
    end

    def urls
      query_string = "SELECT urls.id, urls.url FROM urls JOIN payloads ON urls.id = payloads.url_id GROUP BY urls.id ORDER BY count(urls.id) desc"
      results = DB.fetch(query_string).to_a

      results.collect{|url_hash| Url.new url_hash}


    end

    def self.find_by_identifier identifier
      result = data.select.where(identifier: identifier).first
      Client.new result unless result.nil?
    end

    def self.find_by_root_url url
      result = data.select.where(root_url: url).first
      Client.new result unless result.nil?
    end

  end

end
