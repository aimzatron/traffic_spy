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
  end

end
