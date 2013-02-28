module TrafficSpy

  if ENV["TRAFFIC_SPY_ENV"] == "test"

    DB = Sequel.sqlite

    DB.create_table :clients do
      primary_key :id
      String :identifier
      String :root_url
    end

    DB.create_table :urls do
      primary_key :id
      String :url
      Integer :client_id
    end

    DB.create_table :campaigns do
      primary_key :id
      String :name
      Integer :client_id
    end

    DB.create_table :events do
      primary_key :id
      String :name
      Integer :client_id
    end

    DB.create_table :screen_resolutions do
      primary_key :id
      Integer :width
      Integer :height
    end

    DB.create_table :web_browsers do
      primary_key :id
      String :name
    end

  else
    DB = Sequel.postgres 'traffic-spy'
  end

end

require 'traffic_spy/models/client'
require 'traffic_spy/models/url'
require 'traffic_spy/models/campaign'
require 'traffic_spy/models/event'
require 'traffic_spy/models/screen_resolution'
require 'traffic_spy/models/web_browser'
