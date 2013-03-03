module TrafficSpy

  class OperatingSystem
    attr_reader :id, :name

    def initialize(params)
      @name = params[:name]
      @id = params[:id]

    end

    def save
     id = OperatingSystem.data.insert(name: name)
      OperatingSystem.new OperatingSystem.data.where(id: id).first
    end

    def self.data
      DB.from :operating_systems
    end

    def self.find_by_id id
     result = OperatingSystem.data.where(id: id).first
     result.nil? ? nil : OperatingSystem.new(result)
    end

    def self.find_by_name name
     result = OperatingSystem.data.where(name: name).first
     result.nil? ? nil : OperatingSystem.new(result)
    end
  end

end
