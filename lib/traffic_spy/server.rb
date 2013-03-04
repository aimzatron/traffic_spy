module TrafficSpy
  class Server < Sinatra::Base
    set :view, 'lib/views'

    get '/' do
      erb :index
    end

    not_found do
      erb :error
    end

    def missing_required_source_params?(params)
      params[:identifier].nil? || params[:rootUrl].nil?
    end

    def client_already_exists?(identifier)
      # TOOD: Client.exists?(identifier)
      !DB.from(:clients).select.where(identifier: identifier).empty?
    end

    post '/sources' do
      # client = Client.new params[:identifier], params[:rootUrl]
      # if client.invalid?
      #   halt 400
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

    def missing_required_payload?(params)
      params[:payload].nil?
    end

    post '/sources/:identifier/data' do
      if missing_required_payload?(params)
        halt 400, "Request is incomplete. Missing payload."
      end

      save params[:identifier], params[:payload]



    end

    def identifier_does_not_exist(params)
      params[:identifier].nil?
    end


    post'/sources/:identifier/urls/:data' do
      if identifier_does_not_exist(params)
        halt 400, "Ruh-Roh. Request is incomplete. Identifier does not exist."
      end
    end


    def save identifier, payload
      client = Client.find_by_identifier identifier

      URL.new(client_id: client.id, url:payload[:url]).save

    end


  end
end
