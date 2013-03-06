module TrafficSpy

  if ENV["TRAFFIC_SPY_ENV"] == "test"
    DB = Sequel.sqlite 'db/traffic_spy-test.sqlite3'
  else
    DB = Sequel.postgres 'traffic_spy'
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
