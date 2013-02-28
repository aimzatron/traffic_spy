module TrafficSpy

  class Url

    def initialize(id, url, client_id)
      DB.from(:url).insert id: id, url: url, client_id: client_id
    end

  end

end
