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
  end

end
