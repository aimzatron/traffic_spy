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
      Event.new Event.data.select.order(Sequel.desc(:id)).first
    end

    def request_times

      #join event table with the payloads by event_id

      query_string = %Q{SELECT request_time
        FROM payloads
        JOIN events ON payloads.event_id = events.id
        WHERE events.id = #{id}
      }

      query = DB.fetch query_string

      query.each_with_object(Array.new(24, 0)) do |entry, hours|
        hour = entry[:request_time].hour
        hours[hour] += 1
      end

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

    def self.events_received
      DB.execute("SELECT *
      FROM payloads
      JOIN events
      ON payloads.event_id = events.id;
      GROUP BY event_id
      ORDER BY count(event_id) DESC")
    end

  end

end
