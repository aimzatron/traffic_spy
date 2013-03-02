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
      result = data.select.where(id: id).to_a.first
      result.nil? ? nil : Event.new(result)
    end

    def self.find_by_name name
     result = data.select.where(name: name).to_a.first
     result.nil? ? nil : Event.new(result)
    end

    def self.find_by_client_id client_id
      result = data.select.where(client_id: client_id).to_a.first
      result.nil? ? nil : Event.new(result)
    end

    def self.find_by params
      result = data.select.where(params).first
      result.nil? ? nil : Event.new(result)
    end
  end

end
