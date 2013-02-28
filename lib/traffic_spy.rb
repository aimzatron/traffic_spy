require "traffic_spy/version"
require "sequel"
require "sinatra"

require "traffic_spy/base"


module TrafficSpy

  post '/sources' do
    if params[:identifier].nil? || params[:rootUrl].nil?
      halt(400)
    elsif !DB.from(:clients).select.where(identifier: params[:identifier]).empty?
      halt(403)
    else
      Client.new params[:identifier], params[:rootUrl]
    end
  end

end
