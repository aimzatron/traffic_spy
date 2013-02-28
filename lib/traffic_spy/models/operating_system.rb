module TrafficSpy

  class OperatingSystem
    attr_reader :id, :name

    def initialize(params)
      @name = params[:name]
      @id = params[:id]

    end

    def save
      OperatingSystems.data.insert(name: name)
    end

    def self.data
      DB.from :operating_systems
    end
  end

end
