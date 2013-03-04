module TrafficSpy

  class Client
    attr_reader :id, :identifier, :root_url

    def initialize(params)
      @id = params[:id]
      @identifier = params[:identifier]
      @root_url = params[:root_url]
    end

    def self.data
      DB.from(:clients)
    end

    def save
      id = Client.data.insert(identifier: identifier, root_url: root_url)
      Client.new Client.data.where(id:id).first
    end

    def urls
      query_string = %Q{SELECT urls.id, urls.url
      FROM urls
      JOIN payloads ON urls.id = payloads.url_id
      GROUP BY urls.id
      ORDER BY count(urls.id) desc}

      results = DB.fetch(query_string).to_a

      results = results.collect{|url_hash| Url.new url_hash}


    end

    def events

      query_string = %Q{SELECT * FROM events WHERE events.client_id = #{id}}
      query = DB.fetch(query_string)
      query.collect{|event| Event.new event}

    end

    def web_browsers
      query_string = %Q{SELECT web_browsers.name,
      COUNT(web_browsers.id) as count
      FROM web_browsers
      JOIN payloads ON payloads.browser_id = web_browsers.id
      JOIN urls ON payloads.url_id = urls.id
      WHERE urls.client_id = #{id}
      GROUP BY web_browsers.id
      }

      query = DB.fetch(query_string)
      query.each_with_object({}) do |elem, hash|
        hash[elem[:name]] = elem[:count]
      end

    end

    def operating_systems
      query_string = %Q{SELECT operating_systems.name,
      COUNT(operating_systems.id) as count
      FROM operating_systems
      JOIN payloads ON payloads.os_id = operating_systems.id
      JOIN urls ON payloads.url_id = urls.id
      WHERE urls.client_id = #{id}
      GROUP BY operating_systems.id
      }

      query = DB.fetch(query_string)
      query.each_with_object({}) do |elem, hash|
        hash[elem[:name]] = elem[:count]
      end

    end

    def screen_resolutions
      query_string = %Q{SELECT screen_resolutions.width,
        screen_resolutions.height,
      COUNT(screen_resolutions.id) as count
      FROM screen_resolutions
      JOIN payloads
      ON payloads.screen_resolution_id = screen_resolutions.id
      JOIN urls ON payloads.url_id = urls.id
      WHERE urls.client_id = #{id}
      GROUP BY screen_resolutions.id
      }

      query = DB.fetch(query_string)
      query.each_with_object({}) do |elem, hash|
        hash["#{elem[:width]}x#{elem[:height]}"] = elem[:count]
      end

    end

    def self.find_by_identifier identifier
      result = data.select.where(identifier: identifier).first
      Client.new result unless result.nil?
    end

    def self.find_by_root_url url
      result = data.select.where(root_url: url).first
      Client.new result unless result.nil?
    end

  end

end
