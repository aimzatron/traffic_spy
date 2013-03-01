module TrafficSpy

  class WebBrowser
    attr_reader :name, :id

    def initialize(params)
      @name = params[:name]
      @id = params[:id]

    end

    def save
      WebBrowser.data.insert(name: name)
    end

    def self.data
      DB.from :web_browsers
    end

    def self.find_by_id id
      WebBrowser.new data.select.where(id: id).to_a.first
    end

    def self.find_by_name name
     WebBrowser.new(data.select.where(name: name).to_a.first)
    end
  end

end
