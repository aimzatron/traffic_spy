require "traffic_spy/version"
require "sequel"
require "sinatra"

require "traffic_spy/base"

require "json"


module TrafficSpy

  post '/sources' do
    if params[:identifier].nil? || params[:rootUrl].nil?
      halt(400, "Registration incomplete. Missing params.")
    elsif !DB.from(:clients).select.where(identifier: params[:identifier]).empty?
      halt(403, "An account already exists with this identifier")
    else
      Client.new params[:identifier], params[:rootUrl]
      {identifier: params[:identifier]}.to_json
    end
  end

end
