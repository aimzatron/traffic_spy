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

    def relative_path
        URI(url).path
    end

    def response_times
      query_string = %Q{SELECT response_time AS time
      FROM payloads
      JOIN urls ON urls.id = url_id
      WHERE urls.id = #{id}
      ORDER BY time DESC}

      query = DB.fetch query_string
      query.collect {|entry| entry[:time]}

    end

    def average_response_time
      query_string = %Q{SELECT AVG(response_time) AS time
      FROM payloads
      JOIN urls ON urls.id = url_id
      WHERE url_id = #{id}}


      query = DB.fetch query_string
      query.first[:time]
    end

    def self.find_by_client_id_and_relative_path client_id, path
      client = Client.find_by_id client_id
      url = client.root_url + path
      find_by_url url
    end

  end

end
