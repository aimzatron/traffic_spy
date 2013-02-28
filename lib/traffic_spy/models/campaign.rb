module TrafficSpy

  class Campaign
    attr_reader :name, :id, :client_id

    def initialize(params)

      @id = params[:id]
      @name = params[:name]
      @client_id = params[:client_id]

    end

    def save
      Campaign.data.insert(name: name, client_id: client_id)
    end

    def self.data
      DB.from(:campaigns)
    end
  end

end
