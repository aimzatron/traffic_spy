module TrafficSpy

  class Client

    def initialize(identifier, root_url)
      DB.from(:clients).insert identifier: identifier, root_url: root_url
    end

  end

end
