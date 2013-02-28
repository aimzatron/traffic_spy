module TrafficSpy

  if ENV["TRAFFIC_SPY_ENV"] == "test"

    DB = Sequel.sqlite

    DB.create_table :clients do
      primary_key :id
      String :identifier
      String :root_url
    end

  else
    DB = Sequel.postgres 'traffic-spy'
  end

end

require 'traffic_spy/models/client'
