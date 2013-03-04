module TrafficSpy
  class Server < Sinatra::Base
    set :view, 'lib/views'

    get '/' do
      erb :index
    end

    not_found do
      erb :error
    end

    get '/sources/:identifier' do
      'you need a test for this'
    end

    post '/sources' do
      # client = Client.new params[:identifier], params[:rootUrl]
      # else
      #
      #   client.save
      # end

      if missing_required_source_params?(params)
        halt(400, "Registration incomplete. Missing params.")
      elsif client_already_exists?(params[:identifier])
        halt(403, "An account already exists with this identifier")
      else
        identifier = params[:identifier]
        root_url = params[:rootUrl]

        client = Client.new(identifier: identifier, root_url: root_url)
        client.save

        {identifier: client.identifier}.to_json
      end
    end

    post '/sources/:identifier/data' do
      if missing_required_payload?(params)
        halt 400, "Request is incomplete. Missing payload."
      end

      request = parse_request(params[:payload])

      payload = TrafficSpy::Payload.create(parse_request(params[:payload]))

      if payload.exists?
        halt 403, "Received a duplicate request"
      else
        payload.save
      end

    end

    post'/sources/:identifier/urls' do
      if identifier_does_not_exist(params)
        halt 400, "Ruh-Roh. Request is incomplete. Identifier does not exist."
      end
    end

    post '/sources/:identifier/events' do
      if event_not_defined(params)
        halt 400, "Oh shiz. Request is incomplete. Event not defined."
      end
    end

    post '/sources/:identifier/events/:event_name' do
      if event_name_not_defined(params)
        halt 400, "Snappppp. Request is incomplete. Event name not defined."
      end
    end

    def missing_required_source_params?(params)
      params[:identifier].nil? || params[:rootUrl].nil?
    end

    def missing_required_payload?(params)
      params[:payload].nil?
    end

    def client_already_exists?(identifier)
      # TOOD: Client.exists?(identifier)
      !DB.from(:clients).select.where(identifier: identifier).empty?
    end

    def identifier_does_not_exist(params)
      params[:identifier].nil?
    end

    def save identifier, payload
      client = Client.find_by_identifier identifier
    end

    def parse_request payload_string
      JSON.parse payload_string, symbolize_names: true
    end

    def event_not_defined(params)
      params[:event_id].nil?
    end

    def event_name_not_defined(params)
      params[:name].nil?
    end

  end
end
