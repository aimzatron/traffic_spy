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

    DB.create_table :web_browsers do
      primary_key :id
      String :name
    end

    DB.create_table :ips do
      primary_key :id
      String :address
    end

    DB.create_table :operating_systems do
      primary_key :id
      name :name
    end

    DB.create_table :campaign_events do
      campaign_id :campaign_id
      event_id :event_id
    end

    DB.create_table :screen_resolutions do
      primary_key :id
      Integer :width
      Integer :height
    end

    DB.create_table :payloads do
      Integer :browser_id 
      Integer :event_id 
      DateTime :response_time 
      Integer :request_time 
      Integer :url_id 
      Integer :ip_id 
      Integer :screen_resolution_id 
      Integer :os_id
    end

  else
    DB = Sequel.postgres 'traffic-spy'
  end

end

require 'traffic_spy/models/campaign_event'
require 'traffic_spy/models/client'
require 'traffic_spy/models/url'
require 'traffic_spy/models/campaign'
require 'traffic_spy/models/event'
require 'traffic_spy/models/operating_system'
require 'traffic_spy/models/web_browser'
require 'traffic_spy/models/ip'
require 'traffic_spy/models/screen_resolution'
require 'traffic_spy/models/payload'
