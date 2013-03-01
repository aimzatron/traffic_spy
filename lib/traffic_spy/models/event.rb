module TrafficSpy

  class Event
    attr_reader :name, :client_id, :id

    def initialize(params)
      @name = params[:name]
      @client_id = params[:client_id]
      @id = params[:id]
      # DB.from(:event).insert id: id, name: name, client_id: client_id
    end

    def save
      Event.data.insert(name: name, client_id: client_id)
    end

    def self.data
      DB.from(:events)
    end

    def self.find_by_id id
      Event.new data.select.where(id: id).to_a.first
    end

    def self.find_by_name name
     Event.new(data.select.where(name: name).to_a.first)
    end

    def self.find_by_client_id client_id
      Event.new data.select.where(client_id: client_id).to_a.first
    end
  end

end
