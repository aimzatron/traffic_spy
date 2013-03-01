module TrafficSpy

  class Ip
    attr_reader :address, :id

    def initialize(params)

      @id = params[:id]
      @address = params[:address]

    end

    def save
      Ip.data.insert(address: address)
    end

    def self.data
      DB.from(:ips)
    end

    def self.find_by_id id
      Ip.new data.select.where(id: id).to_a.first
    end

    def self.find_by_address address
     Ip.new(data.select.where(address: address).to_a.first)
    end
  end

end
