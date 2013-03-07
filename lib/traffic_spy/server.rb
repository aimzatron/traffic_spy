module TrafficSpy
  class Server < Sinatra::Base
    set :views, 'lib/views'

    get '/' do
      erb :index
    end

    not_found do
      erb :error
    end

    post '/sources' do
      if missing_required_source_params?(params)
        halt(400, "Registration incomplete. Missing params.")

      elsif Client.exists?(params[:identifier])
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

      if payload.nil?
        halt 400, "There was a problem processing the payload"
      elsif payload.exists?
        halt 403, "Received a duplicate request"
      else
        payload.save
      end

    end

    get '/sources/?' do
      @clients = Client.all
      erb :sources
    end

    get '/sources/:identifier/?' do
      if Client.exists? params[:identifier]
        @client = Client.find_by_identifier params[:identifier]
        erb :application_details
      else
        @identifier = params[:identifier]
        erb :missing_account
      end

    end

    get '/sources/:identifier/urls/*' do
      path = "/#{params[:splat].first}"

      if Client.exists? params[:identifier]
        client = Client.find_by_identifier params[:identifier]
        url = Url.find_by_client_id_and_relative_path client.id, path

        if url.nil?
          @path = path
          erb :no_url
        else
          @url = url
          erb :url
        end
      else
        erb :missing_account
      end

    end

    get '/sources/:identifier/events/?' do
      if Client.exists? params[:identifier]
        @client = Client.find_by_identifier params[:identifier]
        erb :events
      else
        @params[:identifier]
        erb :missing_account
      end
    end

    get '/sources/:identifier/events/*' do
      event_name = params[:splat]
      if Event.exists_for? event_name, params[:identifier]
        client_id = Client.find_by_identifier(params[:identifier]).id
        @event = Event.find_by name: event_name, client_id: client_id
        erb :event
      else
        erb :no_event
      end
    end

    def missing_required_source_params?(params)
      params[:identifier].nil? || params[:rootUrl].nil?
    end

    def missing_required_payload?(params)
      params[:payload].nil?
    end

    def parse_request payload_string
      JSON.parse payload_string, symbolize_names: true
    end


  end
end
