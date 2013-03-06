Sequel.migration do
  change do
    create_table :clients do
      primary_key :id
      String :identifier
      String :root_url
    end

    create_table :urls do
      primary_key :id
      String :url
      Integer :client_id
    end

    create_table :campaigns do
      primary_key :id
      String :name
      Integer :client_id
    end

    create_table :events do
      primary_key :id
      String :name
      Integer :client_id
    end

    create_table :web_browsers do
      primary_key :id
      String :name
    end

    create_table :ips do
      primary_key :id
      String :address
    end

    create_table :operating_systems do
      primary_key :id
      String :name
    end

    create_table :campaign_events do
      Integer :campaign_id
      Integer :event_id
    end

    create_table :screen_resolutions do
      primary_key :id
      Integer :width
      Integer :height
    end

    create_table :payloads do
      Integer :browser_id
      Integer :event_id
      Integer :response_time
      DateTime :request_time
      Integer :url_id
      Integer :ip_id
      Integer :screen_resolution_id
      Integer :os_id
      primary_key :id
    end
  end
end
