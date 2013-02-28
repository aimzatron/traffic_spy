module TrafficSpy

  class Url
    attr_reader :url, :client_id, :id

    def initialize(params)
      @url = params[:url]
      @client_id = params[:client_id]
      @id = params[:id]

    end

    def save
      Url.data.insert(url: url, client_id: client_id)
    end

    def self.data
      DB.from :urls
    end
  end

end
