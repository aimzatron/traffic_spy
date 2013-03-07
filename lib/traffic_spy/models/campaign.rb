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

    def self.find_by_id id
      Campaign.new data.select.where(id: id).to_a.first
    end

    def self.find_by_name name
      Campaign.new(data.select.where(name: name).to_a.first)
    end

#    def self.find_by_client_id client_id
#      Campaign.new data.select.where(client_id: client_id).to_a.first
#    end
  end

end
