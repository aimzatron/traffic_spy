module TrafficSpy

  class Url
    attr_reader :url, :client_id, :id

    def initialize(params)
      @url = params[:url]
      @client_id = params[:client_id]
      @id = params[:id]

    end

    def save
      id = Url.data.insert(url: url, client_id: client_id)
      Url.new Url.data.where(id: id).first
    end

    def self.data
      DB.from :urls
    end

    def self.find_by_id id
      Url.new data.select.where(id: id).to_a.first
    end

    def self.find_by_url url
      result = data.select.where(url:url).to_a.first
      result.nil? ? nil : Url.new(result)
    end

    def request_count
      Payload.find_all_by_url_id(id).count
    end

    def payload_data
      DB.from :payloads_table
    end

    def self.response_query
      DB.execute("SELECT *
      FROM payloads
      JOIN urls
      ON payloads.url_id = urls.id;
      ORDER BY response_time DESC")
    end

    def self.average_response_time
      average = DB.execute("SELECT *
      FROM payloads
      JOIN urls
      ON payloads.url_id = urls.id;
      SELECT url_id, AVG(RESPONSE_TIME)
      GROUP BY url_id
      ORDER BY response_time DESC")

      query = DB.fetch(average)
      result = query.to_s

      result

    end

  end

end
