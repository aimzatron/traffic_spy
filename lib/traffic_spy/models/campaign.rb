module TrafficSpy

  class Campaign

    def initialize(id, name, client_id)
      DB.from(:campaign).insert id: id, name: name, client_id: client_id
    end

  end

end
