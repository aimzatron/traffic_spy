module TrafficSpy

  class Event

    def initialize(id, name, client_id)
      DB.from(:event).insert id: id, name: name, client_id: client_id
    end

  end

end
