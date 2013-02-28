require "traffic_spy/version"
require "sequel"
require "sinatra"

require "traffic_spy/base"


module TrafficSpy

  post '/sources' do
    if params[:identifier].nil? || params[:rootUrl].nil?
      halt(400)
    end
  end

end
