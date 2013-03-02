module TrafficSpy

  class ScreenResolution
    attr_reader :width, :height, :id

    def initialize(params)

      @id = params[:id]
      @width = params[:width]
      @height = params[:height]

    end

    def save
      ScreenResolution.data.insert(width: width, height: height)
    end

    def self.data
      DB.from(:screen_resolutions)
    end

    def self.find_by_resolution width, height
      result = data.select.where(width:width, height:height).to_a.first
      result.nil? ? nil : ScreenResolution.new(result)
    end
  end

end
