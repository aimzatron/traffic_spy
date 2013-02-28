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
  end

end
